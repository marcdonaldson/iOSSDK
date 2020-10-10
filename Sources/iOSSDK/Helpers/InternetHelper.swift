//
//  InternetHelper.swift
//  Fantabulous
//
//  Created by Marc Donaldson on 10/10/2020.
//

import Foundation
import SystemConfiguration
 
public class Reachability {
    public var hostname: String?
    public var isRunning = false
    public var isReachableOnWWAN: Bool
    public var reachability: SCNetworkReachability?
    public var reachabilityFlags = SCNetworkReachabilityFlags()
    public let reachabilitySerialQueue = DispatchQueue(label: "ReachabilityQueue")
    public init(hostname: String) throws {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw Network.Error.failedToCreateWith(hostname)
        }
        self.reachability = reachability
        self.hostname = hostname
        isReachableOnWWAN = true
        try start()
    }
    public init() throws {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            throw Network.Error.failedToInitializeWith(zeroAddress)
        }
        self.reachability = reachability
        isReachableOnWWAN = true
        try start()
    }
    public var status: Network.Status {
        return  !isConnectedToNetwork ? .unreachable :
                isReachableViaWiFi    ? .wifi :
                isRunningOnDevice     ? .wwan : .unreachable
    }
    public var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }()
    public deinit { stop() }
}

public func callout(reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    public guard let info = info else { return }
    DispatchQueue.main.async {
        Unmanaged<Reachability>
            .fromOpaque(info)
            .takeUnretainedValue()
            .flagsChanged()
    }
}

public extension Notification.Name {
    public static let flagsChanged = Notification.Name("FlagsChanged")
}

public struct Network {
    public static var reachability: Reachability!
    public enum Status: String {
        case unreachable, wifi, wwan
    }
    public enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}

public extension Reachability {

    public func start() throws {
        guard let reachability = reachability, !isRunning else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged<Reachability>.passUnretained(self).toOpaque()
        guard SCNetworkReachabilitySetCallback(reachability, callout, &context) else { stop()
            throw Network.Error.failedToSetCallout
        }
        guard SCNetworkReachabilitySetDispatchQueue(reachability, reachabilitySerialQueue) else { stop()
            throw Network.Error.failedToSetDispatchQueue
        }
        reachabilitySerialQueue.async { self.flagsChanged() }
        isRunning = true
    }

    public func stop() {
        defer { isRunning = false }
        guard let reachability = reachability else { return }
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        self.reachability = nil
    }

    var isConnectedToNetwork: Bool {
        return isReachable &&
               !isConnectionRequiredAndTransientConnection &&
               !(isRunningOnDevice && isWWAN && !isReachableOnWWAN)
    }

    var isReachableViaWiFi: Bool {
        return isReachable && isRunningOnDevice && !isWWAN
    }

    /// Flags that indicate the reachability of a network node name or address, including whether a connection is required, and whether some user intervention might be required when establishing a connection.
    var flags: SCNetworkReachabilityFlags? {
        guard let reachability = reachability else { return nil }
        var flags = SCNetworkReachabilityFlags()
        return withUnsafeMutablePointer(to: &flags) {
            SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0))
            } ? flags : nil
    }

    /// compares the current flags with the previous flags and if changed posts a flagsChanged notification
    public func flagsChanged() {
        guard let flags = flags, flags != reachabilityFlags else { return }
        reachabilityFlags = flags
        NotificationCenter.default.post(name: .flagsChanged, object: self)
    }

    /// The specified node name or address can be reached via a transient connection, such as PPP.
    public var transientConnection: Bool { return flags?.contains(.transientConnection) == true }

    /// The specified node name or address can be reached using the current network configuration.
    public var isReachable: Bool { return flags?.contains(.reachable) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set, the kSCNetworkReachabilityFlagsConnectionOnTraffic flag, kSCNetworkReachabilityFlagsConnectionOnDemand flag, or kSCNetworkReachabilityFlagsIsWWAN flag is also typically set to indicate the type of connection required. If the user must manually make the connection, the kSCNetworkReachabilityFlagsInterventionRequired flag is also set.
    public var connectionRequired: Bool { return flags?.contains(.connectionRequired) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.
    public var connectionOnTraffic: Bool { return flags?.contains(.connectionOnTraffic) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established.
    public var interventionRequired: Bool { return flags?.contains(.interventionRequired) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. The connection will be established "On Demand" by the CFSocketStream programming interface (see CFStream Socket Additions for information on this). Other functions will not establish the connection.
    public var connectionOnDemand: Bool { return flags?.contains(.connectionOnDemand) == true }

    /// The specified node name or address is one that is associated with a network interface on the current system.
    public var isLocalAddress: Bool { return flags?.contains(.isLocalAddress) == true }

    /// Network traffic to the specified node name or address will not go through a gateway, but is routed directly to one of the interfaces in the system.
    public var isDirect: Bool { return flags?.contains(.isDirect) == true }

    /// The specified node name or address can be reached via a cellular connection, such as EDGE or GPRS.
    public var isWWAN: Bool { return flags?.contains(.isWWAN) == true }

    /// The specified node name or address can be reached using the current network configuration, but a connection must first be established. If this flag is set
    /// The specified node name or address can be reached via a transient connection, such as PPP.
    public var isConnectionRequiredAndTransientConnection: Bool {
        return (flags?.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]) == true
    }
}

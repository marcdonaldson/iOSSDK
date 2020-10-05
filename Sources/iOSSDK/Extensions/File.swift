//
//  File.swift
//  
//
//  Created by Marc Donaldson on 05/10/2020.
//

import Foundation

public extension Data {
    
    public func toString() -> String {
        return(String(decoding: self, as: UTF8.self)
    }
}

//
//  File.swift
//  
//
//  Created by Marc Donaldson on 05/10/2020.
//

import Foundation

public class Rest {
    
    public static func asyncQuery(address: String,action: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let url = URL(string: address)
        
        let task =  URLSession.shared.dataTask(with: url!,completionHandler: action)
        task.resume()
    }
    
    public static func syncQuery(address: String) -> Data {
        let url = URL(string: address)
        let semaphore = DispatchSemaphore(value: 0)
        
        var result: Data = Data()
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            result = data!
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return result
    }

}

//
//  RestManager+Extension.swift
//  AmiGO
//
//  Created by Alejandro on 19/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation

extension RestManager{
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    enum CustomError: Error{
        case failedToCreateRequest
        case errorOnRequest(code:Int)
    }
    
    struct RestEntity {
        private var values: [String: String] = [:]
        
        mutating func add(value: String, forKey key:String){
            values[key] = value
        }
        
        func value(forKey key:String) -> String?{
            return values[key]
        }
        
        func allValues() -> [String: String]{
            return values
        }
        
        func totalItems() -> Int{
            return values.count
        }
    }

    struct Response {
        var responce: URLResponse?
        var httpStatusCode: Int = 0
        var headers = RestEntity()
        
        init(fromURLResponse response:URLResponse?) {
            guard let response = response else { return }
            self.responce = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields{
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
            
        }
    }

    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        init(withError error: Error) {
            self.error = error
        }
    }
}





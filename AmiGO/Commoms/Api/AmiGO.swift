//
//  AmiGO.swift
//  AmiGO
//
//  Created by Alejandro on 04/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import Moya

enum AmiGO {
    case location(latitude:Double, longitude:Double)
}

extension AmiGO: TargetType{

    var path: String{
        switch self {
            case .location:
                return "/weatherData"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .location:
            return .get
        }
    }
    
    var task: Task {
           switch self {
           case let .location(latitude,longitude):
            return .requestParameters(parameters: ["lat":latitude,"lon":longitude], encoding: URLEncoding.queryString)
       }
    }

   var headers: [String: String]? {
       return nil
   }
    
    var baseURL: URL {
        return URL(string: "http://localhost:3000")!
    }
    
    var sampleData: Data {
        switch self {
        case .location:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }
    
}

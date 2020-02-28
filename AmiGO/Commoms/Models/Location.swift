//
//  Location.swift
//  AmiGO
//
//  Created by Alejandro on 12/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import CoreLocation

class Location:Codable {
    let latitude: Double
    let longitude: Double
    let date: Date
    let dateString: String
    

    init(visit: CLVisit) {
        self.latitude = visit.coordinate.latitude
        self.longitude = visit.coordinate.longitude
        self.date = visit.arrivalDate
        self.dateString = ""
    }
    
    init(latitude:Double, longitude:Double){
        self.latitude = latitude
        self.longitude = longitude
        self.date = Date()
        self.dateString = "Now"
    }

    init(){
        self.latitude = 0
        self.longitude = 0
        self.date = Date()
        self.dateString = "Now"
    }
    
    init(_ json : [String:Any]?){
        self.latitude = 0
        self.longitude = 0
        self.date = Date()
        self.dateString = "Now"
    }
    
    func toJson() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self)
        return String(data: jsonData, encoding: String.Encoding.utf8)!
    }
}

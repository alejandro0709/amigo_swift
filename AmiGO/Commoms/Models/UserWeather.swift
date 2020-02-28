//
//  UserWeather.swift
//  AmiGO
//
//  Created by Alejandro on 21/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation

class UserWeather {
    var name:String
    var userImage: String?
    var temp:Double?
    var latitude:Double?
    var longitude:Double?
    
    init(_ name:String,_ userImage: String?,_ temp:Double?,_ latitude: Double?,_ longitude: Double? ) {
        self.name = name
        self.userImage = userImage
        self.temp = temp
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ temp:Double?,_ latitude: Double?,_ longitude: Double?) {
        self.name = ""
        self.temp = temp
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getUserLocationTempeture() -> String {
        if temp == nil {return "" }
        let tempInCelsius = (temp! - 273.15).rounded(.toNearestOrAwayFromZero)
        return String(tempInCelsius)
    }
}

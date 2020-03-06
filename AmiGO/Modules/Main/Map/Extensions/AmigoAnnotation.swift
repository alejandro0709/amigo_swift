//
//  AmigoAnnotation.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import MapKit

class AmigoAnnotation: NSObject, MKAnnotation  {
    
    public static let SUNNY = "sun"
    public static let CLOUDY = "cloudy"
    public static let STORM = "storm"
    
    var userWeather:UserWeather
    
    var temperatureValue:String? {
        return userWeather.getUserLocationTempeture()
    }
    
    var weatherType:String = SUNNY
    
    var userName:String?{
        return userWeather.name
    }
    
    var userImage:String?{
        return userWeather.userImage
    }
    
    let title: String?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: userWeather.latitude ?? 0, longitude: userWeather.longitude ?? 0)
    }
    
    init(userWeather: UserWeather, weatherType: String) {
        self.userWeather = userWeather
        self.weatherType = weatherType
        self.title = userWeather.name.lowercased().replacingOccurrences(of: " ", with: "_")
        super.init()
     }

}


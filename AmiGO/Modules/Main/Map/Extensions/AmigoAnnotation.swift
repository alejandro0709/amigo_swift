//
//  AmigoAnnotation.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import Mapbox

class AmigoAnnotation: MGLPointAnnotation {
    public static let SUNNY = "sun"
    public static let CLOUDY = "cloudy"
    public static let STORM = "storm"
    
    var tempetureValue:String?
    var weatherType:String = SUNNY
    var userName:String = ""
    var userImage:String?
    
}


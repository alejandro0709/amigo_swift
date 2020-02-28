//
//  WeatherData.swift
//  AmiGO
//
//  Created by Alejandro on 21/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation

class WeatherData: Codable {
    var lat:Double?
    var lon:Double?
    var base: String?
    var clouds: Clouds?
    var cod: Int?
    var coord: Coord?
    var dt: Int?
    var id: Int?
    var main: Main?
    var name: String?
    var sys: Sys?
    var weather: [Weather]?
    var wind: Wind?
}

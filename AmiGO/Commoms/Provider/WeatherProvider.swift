//
//  WeatherProvider.swift
//  AmiGO
//
//  Created by Alejandro on 21/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherProvider {
    func getWeatherByCoordinates(latitude: Double, longitude: Double) -> Observable<RestManager.Results>
}

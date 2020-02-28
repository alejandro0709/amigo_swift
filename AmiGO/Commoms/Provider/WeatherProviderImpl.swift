//
//  WeatherProviderImpl.swift
//  AmiGO
//
//  Created by Alejandro on 21/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

class WeatherProviderImpl: WeatherProvider {
    func getWeatherByCoordinates(latitude: Double, longitude: Double) -> Observable<RestManager.Results> {
        let rest = RestManager()
        return rest.makeRequestWithObservable(toStringURL: "http://localhost:3000/weatherData?lat=\(latitude)&lon=\(longitude)", withHttpMethod: .get)
    }
    
}

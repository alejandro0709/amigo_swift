//
//  MapRepository.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

protocol MapRepository {
    func updateUserLocation(location: Location)
    
    func getUserWeatherList() -> Observable<UserWeather>
}

//
//  MapViewModel.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

class MapViewModel {
    var repository:MapRepository
    var locationPSubject = PublishSubject<Location>()
    
    init(mapRepository:MapRepository){
        self.repository = mapRepository
    }
    
    func attempUpdateUserLocation(location: Location){
        if !self.shouldShareLocation(){
            return
        }
        self.repository.updateUserLocation(location: location)
    }
    
    func updateCurrentLocation(latitude: Double , longitude: Double){
        let location = Location.init(latitude: latitude, longitude: longitude)
        self.locationPSubject.onNext(location)
    }
    
    func shouldShareLocation() -> Bool {
        return UserDefaults.standard.bool(forKey: "share_location")
    }
    
    func getMapAnnotations() -> Observable<AmigoAnnotation>{
        return self.repository.getUserWeatherList().map { userWeather -> AmigoAnnotation in
            let annotation = AmigoAnnotation(userWeather:userWeather, weatherType: AmigoAnnotation.STORM)
            return annotation
        }
    }
    
}

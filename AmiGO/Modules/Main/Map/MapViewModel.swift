//
//  MapViewModel.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import Mapbox

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
            let annotation = AmigoAnnotation()
            annotation.tempetureValue = userWeather.getUserLocationTempeture()
            annotation.coordinate = CLLocationCoordinate2D(latitude: userWeather.latitude!, longitude: userWeather.longitude!)
            annotation.weatherType = AmigoAnnotation.STORM
            annotation.userName = userWeather.name
            annotation.userImage = userWeather.userImage
            annotation.title = userWeather.name.lowercased().replacingOccurrences(of: " ", with: "_")
            return annotation
        }
    }
    
}

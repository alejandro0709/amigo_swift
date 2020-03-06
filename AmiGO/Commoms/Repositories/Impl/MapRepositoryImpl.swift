//
//  MapRepositoryImpl.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

class MapRepositoryImpl: MapRepository {

    let userProvider: UserProvider
    let weatherProvider: WeatherProvider
    let disposeBag = DisposeBag()
    
    init(userProvider:UserProvider,weatherProvider: WeatherProvider) {
        self.userProvider = userProvider
        self.weatherProvider = weatherProvider
    }
    
    func updateUserLocation(location: Location) {
        self.userProvider.updateCurrentLocation(location: location)
    }
    
    func getUserWeatherList() -> Observable<UserWeather> {
        return Observable<UserWeather>.create{ observer in
            self.userProvider.getAllUser().subscribe(onNext: { user in
                if user.location != nil {
                    self.attemptGetUserWeather(user, observer)
                }
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func attemptGetUserWeather(_ user:User,_ observer:AnyObserver<UserWeather>){
        weatherProvider.getWeatherTemperatureByCoordinates(latitude: user.location!.latitude, longitude: user.location!.longitude).subscribe(onNext: { result in
            let userData = UserWeather(user.name! ,user.image, result, user.location?.latitude, user.location?.longitude)
            observer.onNext(userData)
        }, onError: { error in
            observer.onError(error)
        }).disposed(by: disposeBag)
    }
    
}

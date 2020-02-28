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
        weatherProvider.getWeatherByCoordinates(latitude: user.location!.latitude, longitude: user.location!.longitude).subscribe(onNext: { result in
            if result.error != nil{
                observer.onError(result.error!)
            } else {
                if let data = result.data {
                    let temp = self.getTempFromResponse(data)
                    let userData = UserWeather(user.name! ,user.image, temp, user.location?.latitude, user.location?.longitude)
                    observer.onNext(userData)
                }
            }
        }, onError: { error in
            observer.onError(error)
        }).disposed(by: disposeBag)
    }
    
    private func getTempFromResponse(_ data: Data) -> Double?{
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:AnyObject]]
           if json?.count == 0 { return nil }
           guard case let main as [String:AnyObject] = json?[0]["main"] else { return nil }
           if main["temp"] != nil { return main["temp"] as? Double }
           return nil
   }
    
    
    
    
}

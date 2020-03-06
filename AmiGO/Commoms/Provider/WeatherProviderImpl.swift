//
//  WeatherProviderImpl.swift
//  AmiGO
//
//  Created by Alejandro on 21/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class WeatherProviderImpl: WeatherProvider {
    func getWeatherTemperatureByCoordinates(latitude: Double, longitude: Double) -> Observable<Double?> {
        return Observable.create{ observer in
            let provider = MoyaProvider<AmiGO>()
            provider.request(.location(latitude: latitude, longitude: longitude)){ result in
                switch result{
                    case .success(let response):
                        let temperature = self.getTempFromResponse(response.data)
                        observer.onNext(temperature)
                        break
                    case .failure(let error):
                        observer.onError(error)
                        break
                }
           }
            return Disposables.create()
        }
        
//        let rest = RestManager()
//        return rest.makeRequestWithObservable(toStringURL: "http://localhost:3000/weatherData?lat=\(latitude)&lon=\(longitude)", withHttpMethod: .get)
    }
    
    private func getTempFromResponse(_ data: Data) -> Double?{
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:AnyObject]]
              if json?.count == 0 { return nil }
              guard case let main as [String:AnyObject] = json?[0]["main"] else { return nil }
              if main["temp"] != nil { return main["temp"] as? Double }
              return nil
      }
    
}

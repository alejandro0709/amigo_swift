//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Swinject
import RxSwift


class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    var viewModel: MapViewModel?
    let disposeBag = DisposeBag()
        
    fileprivate var mainView: MapControllerView {
        return self.view as! MapControllerView
    }
    
    override func loadView() {
        view = MapControllerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRequestLocation()
        self.setupViewModel()
    }
    
    func setupViewModel(){
        self.viewModel = Container.sharedContainer.resolve(MapViewModel.self)
        self.viewModel?.locationPSubject.subscribe(onNext: {location in
            self.mainView.setCenterLocation(latitude: location.latitude, longitude: location.longitude)
            }).disposed(by: disposeBag)
        self.viewModel?.getMapAnnotations().observeOn(MainScheduler.instance).subscribe( onNext: { annotation in
            self.mainView.addOrUpdateAnnotation(annotation)
        }).disposed(by: disposeBag)
    }
        
    private func setupRequestLocation(){
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 1
        locationManager.distanceFilter = 3

        // 2
        locationManager.allowsBackgroundLocationUpdates = true

        // 3
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        self.viewModel?.updateCurrentLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.viewModel?.updateCurrentLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}

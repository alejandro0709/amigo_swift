//
//  MapControllerView.swift
//  AmiGO
//
//  Created by Alejandro on 14/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout
import MapKit

class MapControllerView: UIView,MKMapViewDelegate {
    
    fileprivate let rootFlexContainer = UIView()
    var mapView = MKMapView()
    let regionRadius: CLLocationDistance = 220
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       override func layoutSubviews() {
           super.layoutSubviews()

           // 1) Layout the contentView & rootFlexContainer using PinLayout
           rootFlexContainer.pin.all(pin.safeArea)

           rootFlexContainer.pin.top().left().right().bottom()

           // 2) Let the flexbox container layout itself and adjust the height
           rootFlexContainer.flex.layout()

       }
    
    init() {
        super.init(frame: .zero)
        
        self.mapView.delegate = self
        rootFlexContainer.flex
            .backgroundColor(UIColor.white)
                .justifyContent(.end)
            .define { flex in
                flex.addItem(mapView)
                .width(100%)
                .height(100%)
        }
                
        addSubview(rootFlexContainer)
    }
    
    func addOrUpdateAnnotation(_ annotation: AmigoAnnotation){
        if mapView.annotations.count != 0 {
            updateAnnotationIfExist(annotation)
        }else{
            mapView.addAnnotation(annotation)
        }
        mapView.flex.markDirty()
        setNeedsLayout()
    }
    
    private func updateAnnotationIfExist(_ annotation: AmigoAnnotation){
        
        guard let foundAnnotation = mapView.annotations.first(where: {value -> Bool in
            return value.title == annotation.title
        }) else {
            mapView.addAnnotation(annotation)
            return
        }
        
        self.mapView.removeAnnotation(foundAnnotation)
        self.mapView.addAnnotation(annotation)
    }
    
    func setCenterLocation(latitude: Double, longitude: Double){
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.flex.markDirty()
        self.setNeedsLayout()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       if annotation is MKUserLocation { return nil }
        
        let reuseIdentifier = "\(String(describing: annotation.title))"
        
       var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
    
       if annotationView == nil {
         annotationView = AmigoAnnotationView.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
       } else {
         annotationView!.annotation = annotation
       }
       return annotationView
     }
    
}

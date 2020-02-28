//
//  MapControllerView.swift
//  AmiGO
//
//  Created by Alejandro on 14/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import FlexLayout
import PinLayout

class MapControllerView: UIView, MGLMapViewDelegate {
    
    fileprivate let rootFlexContainer = UIView()
    var mapView: MGLMapView = {
            let map = MGLMapView()
//            map.styleURL = URL(string: "mapbox://styles/mapbox/streets-v11")
            map.styleURL = MGLStyle.satelliteStyleURL
        
//            map.showsUserLocation = true
            return map
        }()
    
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
        if mapView.annotations != nil {
            updateAnnotationIfExist(annotation)
        }else{
            mapView.addAnnotation(annotation)
        }
        mapView.flex.markDirty()
        setNeedsLayout()
    }
    
    private func updateAnnotationIfExist(_ annotation: AmigoAnnotation){
        guard let valueAt = mapView.annotations?.firstIndex(where: { value -> Bool in
            return value.title == annotation.title
        }) else {
            mapView.addAnnotation(annotation)
            return
        }
        
        let annotationToDelete = self.mapView.annotations?[valueAt]
        self.mapView.removeAnnotation(annotationToDelete!)
        mapView.addAnnotation(annotation)
    }
    
//    fileprivate func setupMarker(_ latitude: Double, _ longitude: Double) {
//        if mapView.annotations != nil {
//            mapView.removeAnnotations(mapView.annotations!)
//        }
//
//        let annotation = AmigoAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude+0.0006)
//        annotation.tempetureValue = "20"
//        mapView.addAnnotation(annotation)
//
//        let annotation1 = AmigoAnnotation()
//        annotation1.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        annotation1.tempetureValue = "36"
//        annotation1.weatherType = AmigoAnnotation.STORM
//        mapView.addAnnotation(annotation1)
//
//        let annotation2 = AmigoAnnotation()
//        annotation2.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude-0.0006)
//        annotation2.tempetureValue = "40"
//        annotation2.weatherType = AmigoAnnotation.CLOUDY
//        mapView.addAnnotation(annotation2)
//    }
    
    func setCenterLocation(latitude: Double, longitude: Double){
        mapView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoomLevel: 17, animated: true)
//        setupMarker(latitude, longitude)
        mapView.flex.markDirty()
        self.setNeedsLayout()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    // Wait for the map to load before initiating the first camera movement.
     
    // Create a camera that rotates around the same center point, rotating 180°.
    // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
//    let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, altitude: 4500, pitch: 15, heading: 180)
//
//    // Animate the camera movement over 5 seconds.
//    mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        let reuseIdentifier = "\(String(describing: annotation.title))"
         
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
         
        if annotationView == nil {
            annotationView = AmigoAnnotationView()
            (annotationView as! AmigoAnnotationView).setupData(temperuteValue: (annotation as! AmigoAnnotation).tempetureValue ?? nil ,weatherImageName: (annotation as! AmigoAnnotation).weatherType, userImage: "")
        } else{
            (annotationView as! AmigoAnnotationView).updateData(temperuteValue: (annotation as! AmigoAnnotation).tempetureValue ?? nil ,weatherImageName: (annotation as! AmigoAnnotation).weatherType)
        }
        
         
        return annotationView
    }
}

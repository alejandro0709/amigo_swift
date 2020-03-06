//
//  AmigoAnnotationView.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import FlexLayout
import PinLayout
import MapKit

class AmigoAnnotationView: MKAnnotationView {
    private var rootFlexContainer = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tempetureLabel: UILabel = {
        let label = UILabel()
        label.text = "35"
        label.font =  UIFont.init(name: "MontserratAlternates-Bold", size: 17)
        label.textColor = UIColor.textDarkBlue
        return label
    }()
    
    var weatherImage:UIImageView = {
        let image = UIImageView(image: UIImage(named: "sun"))
        return image
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setupDataFromAnnotation(annotation)
        rootFlexContainer.flex
            .width(118)
            .height(70)
            .alignItems(.start)
            .justifyContent(.end)
            .define { flex in
                
                flex.addItem()
                    .width(46)
                    .height(46)
                    .backgroundColor(UIColor.systemPink)
                    .view?.layer.cornerRadius = 23
                
                let view = flex.addItem().backgroundColor(UIColor.white)
                    .position(.absolute)
                    .alignSelf(.end)
                    .top(0)
                    .right(0)
                    .height(32)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .direction(.row)
                    .paddingLeft(10)
                    .paddingRight(10)
                    .define{ flex in
                        flex.addItem(weatherImage).width(20).height(20)
                        flex.addItem(tempetureLabel).grow(1).marginLeft(10)
                    }.view!
                
                view.layer.cornerRadius = 16
                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        
        addSubview(rootFlexContainer)
    }
    private func setupDataFromAnnotation(_ annotation: MKAnnotation?){
        if annotation == nil { return }
        
        let convAnnotation  = annotation as! AmigoAnnotation
        guard let valueTemp = convAnnotation.temperatureValue else {
            return
        }
        tempetureLabel.text = valueTemp
        
        weatherImage.image = UIImage(named: convAnnotation.weatherType)
    }
    
    private func setTemperature(temp: String?){
        guard let valueTemp = temp else {
            return
        }
        tempetureLabel.text = valueTemp
        tempetureLabel.flex.markDirty()
    }
    
    private func setWeatherImage(imageName: String){
        weatherImage.image = UIImage(named: imageName)
        weatherImage.flex.markDirty()
    }
    
    func setupData(temperuteValue:String?, weatherImageName:String, userImage: String){
        setTemperature(temp: temperuteValue)
        setWeatherImage(imageName: weatherImageName)
//        set user image
    }
    
    func updateData(temperuteValue:String?, weatherImageName:String){
        setTemperature(temp: temperuteValue)
        setWeatherImage(imageName: weatherImageName)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       rootFlexContainer.pin.top().left().right().bottom()
       rootFlexContainer.flex.layout()
    }
}

//
//  CustomAnnotation.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import Mapbox
import FlexLayout
import PinLayout

class AmigoAnnotation: MGLAnnotationView {
    private var rootFlexContainer = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        rootFlexContainer.flex
            .define { flex in
                let view = flex.addItem().backgroundColor(UIColor.systemBlue)
                    .width(50).height(50).view!
                
                view.layer.cornerRadius = 25
                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        
        addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       rootFlexContainer.pin.top().left().right().bottom()
       rootFlexContainer.flex.layout()
    }
}

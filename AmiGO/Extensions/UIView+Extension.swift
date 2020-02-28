//
//  UIView+Extension.swift
//  AmiGO
//
//  Created by Alejandro on 15/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    enum RoundType {
        case top
        case left
        case right
        case none
        case bottom
        case both
    }


    func round(with type: RoundType, radius: CGFloat = 3.0) {
        var corners: UIRectCorner

        switch type {
        case .top:
            corners = [.topLeft, .topRight]
        case .none:
            corners = []
        case .bottom:
            corners = [.bottomLeft, .bottomRight]
        case .both:
            corners = [.allCorners]
        case .right:
            corners = [.bottomRight, .topRight]
        case .left:
            corners = [.topLeft, .bottomLeft]
        }


        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
           let gradient: CAGradientLayer = CAGradientLayer()
           gradient.colors = colours
           gradient.locations = [0.0, 1.0]
           gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
           gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
           gradient.frame = self.layer.frame
           self.layer.insertSublayer(gradient, at: 0)
       }
}

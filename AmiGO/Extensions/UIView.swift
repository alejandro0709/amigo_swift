//
// Created by Alejandro on 08/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
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
}
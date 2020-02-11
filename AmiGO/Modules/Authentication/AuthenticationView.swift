//
// Created by Alejandro on 08/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout


class AuthenticationView: UIView {

    fileprivate let rootFlexContainer = UIView()

    var delegate: FbButtonDelegate?

    var fb_button = UIView()

    var fb_label: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "MontserratAlternates-Bold", size: 15)
        label.text = "Login with facebook"
        label.textColor = UIColor.white
        label.font = font
        return label;
    }()


    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white

        rootFlexContainer.flex
                .backgroundColor(UIColor(red: 244 / 255, green: 247 / 255, blue: 254 / 255, alpha: 1))
                .justifyContent(.end)
                .define { flex in

                    flex.addItem()
                            .position(.absolute)
                            .alignSelf(.center)
                            .height(100%).width(320)
                            .direction(.rowReverse)
                            .define { flex in

                                flex.addItem()
                                        .width(36%)

                                flex.addItem(UIImageView(image: UIImage(named: "bkg_line")))
                                        .height(100%)
                                        .width(12%)

                                flex.addItem(UIImageView(image: UIImage(named: "LOGO")))
                                        .position(.absolute)
                                        .alignSelf(.center)
                                        .top(110)
                                        .height(330).width(100%)
                            }

                    flex.addItem()
                            .paddingLeft(25)
                            .paddingRight(25)
                            .bottom(50)
                            .define { flex in
                                fb_button = flex.addItem().width(100%)
                                        .backgroundColor(UIColor(red: 45 / 255, green: 65 / 255, blue: 110 / 255, alpha: 1))
                                        .alignSelf(.center)
                                        .justifyContent(.center)
                                        .height(54)

                                        .define { flex in

                                    flex.addItem(fb_label)
                                            .alignSelf(.center)

                                    flex.addItem(UIImageView(image: UIImage(named: "icon_fb")))
                                            .position(.absolute)
                                            .alignSelf(.start)
                                            .width(32)
                                            .height(32)
                                            .left(14)
                                }.view!

                                fb_button.round(with: .both, radius: 27)
                            }
                }
        addSubview(rootFlexContainer)

        fb_button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(gesture:))))
    }

    @objc func buttonTapped(gesture: UIGestureRecognizer) {
        delegate?.onButtonPressed()
    }

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
}

protocol FbButtonDelegate {
    func onButtonPressed()
}

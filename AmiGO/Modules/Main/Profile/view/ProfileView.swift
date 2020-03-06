//
//  ProfileView.swift
//  AmiGO
//
//  Created by Alejandro on 15/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout
import Kingfisher

class ProfileView: UIView {
    private var rootFlexContainer = UIView()
    
    var delegate:ProfileViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageContainer:UIView!
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "MontserratAlternates-Bold", size: 11)
        return button
    }()
    
    let userNameTextView: UITextView = {
        let textField = UITextView()
        textField.text = "Name"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textField.textColor = UIColor.principalBlue.withAlphaComponent(0.5)
        textField.keyboardAppearance = .dark
        textField.textAlignment = .left
        textField.backgroundColor = UIColor.white.withAlphaComponent(0)
        return textField
    }()
    
    let locationLabel:UILabel = {
        let label = UILabel()
        label.text = "Share my current location"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor.textDarkBlue
        return label
    }()
    
    let shareLocationSwitch: UISwitch = {
        let activate = UISwitch()
        activate.thumbTintColor = UIColor.principalBlue
        activate.onTintColor = UIColor.principalBlue.withAlphaComponent(0.3)
        return activate
    }()
    
    var verticalRectGradient: UIView = UIView()
    
    let bkgLine:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bkg_line")
        return imageView
    }()
    
    var userImage = UIImageView()

   

    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.white
        
//        https://picsum.photos/id/237/200/300

        rootFlexContainer.flex
            .backgroundColor(UIColor.white)
            .define { flex in
                flex.addItem()
                    .backgroundColor(.principalBlue)
                    .height(43%)
                    .justifyContent(.center)
                    .define { flex in
                        
                        flex.addItem(logoutButton)
                            .position(.absolute)
                            .right(20)
                            .alignSelf(.end)
                            .width(65).view!.layer.cornerRadius = 13
                        
                         flex.addItem()
                            .alignSelf(.center)
                            .width(190)
                            .height(190)
                            .backgroundColor(UIColor.white.withAlphaComponent(0.1))
                            .justifyContent(.center)
                            .define{ flex in
                                flex.addItem(userImage)
                                    .width(145)
                                    .height(145)
                                    .alignSelf(.center)
                                    
                                
                        }.view!.layer.cornerRadius = 95
                }
                
                flex.addItem()
                    .grow(1)
                    .backgroundColor(UIColor.white)
                    .define { flex in
                        flex.addItem()
                        .width(100%)
                        .height(60)
                            .backgroundColor(UIColor.principalBlue.withAlphaComponent(0.1))
                            .direction(.row)
                            .alignItems(.center)
                            .define { flex in
                                flex.addItem().width(14%)
                                flex.addItem(userNameTextView)
                                    .grow(1)
                                flex.addItem().width(14%)
                        }
                        
                        flex.addItem()
                            .marginTop(50)
                            .direction(.row)
                            .define { flex in
                            
                                flex.addItem().width(14%)
                                flex.addItem(locationLabel)
                                    .grow(1)
                                
                                flex.addItem(shareLocationSwitch)
                                flex.addItem().width(14%)
                        }
                        
                        
                }
                
                self.verticalRectGradient = flex.addItem()
                    .alignSelf(.start)
                    .position(.absolute)
                    .left(25%)
                    .top(0)
                    .bottom(0)
                    .width(40)
                    .height(100%)
                    .view!
        }
        
        self.userNameTextView.delegate = self
        
        self.shareLocationSwitch.addTarget(self, action: #selector(onValueChanged), for: .valueChanged)
        
        self.logoutButton.addTarget(self, action: #selector(onLogoutPressed), for: .touchUpInside)
        
        userImage.kf.indicatorType = .activity
        
        let url = URL(string: "https://picsum.photos/id/237/250/250")
//        let url = URL(string: "https://picsum.photos/id/0/250/250")
//        let url = URL(string: "https://picsum.photos/id/1060/250/250")
        
        let processor = RoundCornerImageProcessor(cornerRadius: 125)
        userImage.kf.setImage(with: url, options: [.transition(.fade(0.2)),.processor(processor)])
        
        addSubview(rootFlexContainer)
    }
    
    func setupVerticalRectGradient(){
        let layer = CAGradientLayer()
        layer.frame = self.verticalRectGradient.frame
        layer.colors = [UIColor.gradientStartColor.cgColor,UIColor.gradientCenterColor.cgColor,
                        UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        verticalRectGradient.layer.sublayers?.removeAll()
        verticalRectGradient.layer.addSublayer(layer)
        verticalRectGradient.flex.markDirty()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.top().left().right().bottom()
        logoutButton.flex.top(pin.safeArea.top + 20)
        rootFlexContainer.flex.layout()
       }
    
    @objc func onValueChanged(_ uiSwitch: UISwitch){
        self.delegate?.shareLocationSwitchChange(value: uiSwitch.isOn)
    }
    
    @objc func onLogoutPressed(){
        self.delegate?.onLogoutPressed()
    }

}

extension ProfileView: UITextViewDelegate {

    public func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textUserNameDidChange(text: textView.text)
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.principalBlue.withAlphaComponent(0.5){
            textView.text = ""
            textView.textColor = UIColor.principalBlue.withAlphaComponent(1)
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Name"
            textView.textColor = UIColor.principalBlue.withAlphaComponent(0.5)
        }
    }
}

protocol ProfileViewDelegate{
    func textUserNameDidChange(text:String)
    func shareLocationSwitchChange(value: Bool)
    func onLogoutPressed()
}

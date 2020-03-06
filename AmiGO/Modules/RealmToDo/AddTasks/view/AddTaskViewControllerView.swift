//
//  AddTaskViewControllerView.swift
//  AmiGO
//
//  Created by Alejandro on 03/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

protocol AddTaskViewDelegate {
    func onAddModTaskPressed()
}

class AddTaskViewControllerView: UIView {
    var delegate: AddTaskViewDelegate?
    
    fileprivate var rootFlexContainer = UIView()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Task title:"
        label.font = UIFont.init(name: "MontserratAlternates-Bold", size: 16)
        label.textColor = UIColor.textDarkBlue
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Task description:"
        label.font = UIFont.init(name: "MontserratAlternates-Bold", size: 16)
        label.textColor = UIColor.textDarkBlue
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "MontserratAlternates-Bold", size: 16)
        return button
    }()
    
    var actionContainer: UIView!
    
    let inputTextField: UITextView = {
           let textField = UITextView()
           textField.backgroundColor = UIColor.black.withAlphaComponent(0.05)
           textField.textAlignment = .left
           textField.textColor = UIColor.darkText
           textField.keyboardAppearance = .dark
           textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
           return textField
       }()
    
    let titleTextField: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        textField.textAlignment = .left
        textField.textColor = UIColor.darkText
        textField.keyboardAppearance = .dark
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return textField
    }()
    
    var inputRoot:UIView!
    
    required init?(coder aDecoder: NSCoder) {
              fatalError("init(coder:) has not been implemented")
          }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        rootFlexContainer.flex
            .backgroundColor(.white)
        .paddingLeft(16)
        .paddingRight(15)
            .define { flex in
                flex.addItem(titleLabel).width(100%).height(20)
                    .marginTop(20)
                
                flex.addItem(titleTextField).width(100%).height(40)
                    .marginTop(8)
                    .view!.layer.cornerRadius = 6
                
                flex.addItem(descriptionLabel).width(100%).height(20)
                .marginTop(20)

                flex.addItem(inputTextField)
                .grow(1)
                .shrink(1)
                .marginTop(8)
                .view!.layer.cornerRadius = 6
            
                actionContainer = flex.addItem()
                                    .width(100%)
                    .paddingLeft(16).paddingRight(16)
                                    .define({ flex in
                                        flex.addItem(addButton).height(45).backgroundColor(UIColor.principalBlue.withAlphaComponent(0.35)).marginTop(8).view!.layer.cornerRadius = 6
                                    }).view!
                
        }
        addSubview(rootFlexContainer)
        
        self.addButton.addTarget(self, action: #selector(onAddbuttonPressed), for: .touchUpInside)
    }
    
    @objc func onAddbuttonPressed(){
        self.delegate?.onAddModTaskPressed()
    }
    
    func setupData(_ task:Tasks){
        
        titleTextField.text = task.title
        titleTextField.flex.markDirty()
        
        inputTextField.text = task.taskDescription
        inputTextField.flex.markDirty()
        
        addButton.setTitle("Modify", for: .normal)
        addButton.flex.markDirty()
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin
            .top(pin.safeArea)
            .bottom(pin.safeArea)
                .left(pin.safeArea)
                .right(pin.safeArea)

        rootFlexContainer.flex.layout()
    }
}

extension AddTaskViewControllerView: UITextFieldDelegate{
    
}

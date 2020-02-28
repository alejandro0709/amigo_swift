//
//  TasksView.swift
//  AmiGO
//
//  Created by Alejandro on 27/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit

class TasksView: UIView {
    
    private var rootFlexContainer = UIView()
    let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "MontserratAlternates-Bold", size: 11)
        return button
    }()
    
    var tableView: UITableView

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    init() {
        tableView = UITableView.init(frame: .zero)
        tableView.backgroundColor = UIColor.systemTeal
        
        super.init(frame: .zero)
        
        rootFlexContainer.flex
            .backgroundColor(UIColor.white)
            .define { flex in
                flex.addItem(tableView)
                    .position(.absolute)
                .paddingTop(15)
                .top(16)
                .grow(1)
                
                flex.addItem(logoutButton)
                    .backgroundColor(UIColor.systemRed)
                    .position(.absolute)
                .right(8)
                .alignSelf(.end)
                .width(60).view!.layer.cornerRadius = 13
        }
        addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
        rootFlexContainer.pin.top().left().right().bottom()
        rootFlexContainer.flex.layout()
        
        logoutButton.pin.top(pin.safeArea.top + 8)
        logoutButton.flex.layout();
        
        tableView.pin.below(of: logoutButton).left().right().bottom()
        tableView.flex.layout()
      
    }
}

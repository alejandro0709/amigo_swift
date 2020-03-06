//
//  TaskView.swift
//  AmiGO
//
//  Created by Alejandro on 05/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class TaskView: UIView {
    private var rootFlexContainer = UIView()
    var delegate: TasksViewDelegate?
    
    let addTask: UIButton = {
            let button = UIButton()
            button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            button.setTitle("Add", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.init(name: "MontserratAlternates-Bold", size: 11)
            return button
        }()

        private var headerView: UIView!

        var titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Realm ToDo"
            label.font = UIFont.init(name: "MontserratAlternates-Bold", size: 20)
            label.textColor = UIColor.textDarkBlue
            return label
        }()

        var tableView: UITableView

        fileprivate let flowLayout: UICollectionViewFlowLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 8
            flowLayout.minimumInteritemSpacing = 8
            return flowLayout
        }()
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    init() {
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        
        tableView.separatorColor = .white
        

        super.init(frame: .zero)

        rootFlexContainer.flex
                .backgroundColor(UIColor.white)
                .define { flex in

                    self.headerView = flex.addItem()
                            .direction(.row)
                            .paddingTop(16)
                            .define { flex in

                        flex.addItem(titleLabel)
                                .grow(1)
                                .marginRight(8)
                                .marginLeft(20)

                        flex.addItem(addTask)
                                .marginBottom(2)
                            .backgroundColor(UIColor.principalBlue)
                                .right(16)
                            .alignSelf(.center)
                                .width(60).view!.layer.cornerRadius = 13
                    }.view!

                    flex.addItem(tableView)
                            .position(.absolute)
                            .paddingTop(16)
                            .marginTop(20)
                            .grow(1)
                }

//        self.tableView.register(TaskUICollectionViewCell.self, forCellWithReuseIdentifier: TaskUICollectionViewCell.reuseIdentifier)
        self.tableView.register(TaskUITableViewCell.self, forCellReuseIdentifier: TaskUITableViewCell.reuseIdentifier)
        self.addTask.addTarget(self, action: #selector(onAddTaskPressed), for: .touchUpInside)
        addSubview(rootFlexContainer)
    }
    
    @objc func onAddTaskPressed(){
        self.delegate?.onAddTask()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin
                .top()
                .bottom()
                .left(pin.safeArea)
                .right(pin.safeArea)

        rootFlexContainer.flex.layout()

        headerView.pin.top(pin.safeArea)
        headerView.flex.layout();

        tableView.pin.below(of: headerView).left().right().bottom(pin.safeArea)
        tableView.flex.layout()

    }
}

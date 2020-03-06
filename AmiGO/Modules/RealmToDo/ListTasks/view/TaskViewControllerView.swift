//
//  TaskViewControllerView.swift
//  AmiGO
//
//  Created by Alejandro on 03/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

protocol TasksViewDelegate {
    func onAddTask()
}

class TaskViewControllerView: UIView {
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

        var collectionView: UICollectionView

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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white

        super.init(frame: .zero)

        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8

            let padding: CGFloat = 8
            layout.sectionInset = .init(top: padding, left: 0, bottom: 16, right: 0)
            
            if #available(iOS 11.0, *) {
                layout.sectionInsetReference = .fromSafeArea
            }
        }

        
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

                    flex.addItem(collectionView)
                            .position(.absolute)
                            .paddingTop(16)
                            .marginTop(20)
                            .grow(1)
                }

        self.collectionView.register(TaskUICollectionViewCell.self, forCellWithReuseIdentifier: TaskUICollectionViewCell.reuseIdentifier)
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

        collectionView.pin.below(of: headerView).left().right().bottom(pin.safeArea)
        collectionView.flex.layout()

    }
}

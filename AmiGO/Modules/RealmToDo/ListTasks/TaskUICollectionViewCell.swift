//
//  TaskUICollectionCell.swift
//  AmiGO
//
//  Created by Alejandro on 03/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class TaskUICollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "taskCellIdentifier"
    
    var taskNameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            label.textColor = UIColor.darkText
            return label
        }()
        
        var taskDescriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = UIColor.darkText.withAlphaComponent(0.8)
            label.numberOfLines = 0
            return label
        }()

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.layout()
        }

        private func layout() {
            contentView.flex.layout(mode: .adjustHeight)
        }
       
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            
            
            self.contentView
                .flex
                .paddingLeft(16)
                .paddingRight(12)
                .define { (flex) in
                    flex.addItem(taskNameLabel)
                    flex.addItem(taskDescriptionLabel)
            }
            taskDescriptionLabel.sizeToFit()
        }
    
 
    
    func setupData(withTask task:Tasks){
        self.taskNameLabel.text = task.title
        self.taskNameLabel.flex.markDirty()
        self.taskDescriptionLabel.text = task.taskDescription
        self.taskDescriptionLabel.flex.markDirty()
        setNeedsLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }

}

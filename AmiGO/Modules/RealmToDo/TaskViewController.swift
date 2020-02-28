//
//  TaskViewController.swift
//  AmiGO
//
//  Created by Alejandro on 27/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit

class TaskViewController: UIViewController {
    
    fileprivate var mainView: TasksView {
        return self.view as! TasksView
    }
    
    override func loadView() {
        view = TasksView()
    }
}

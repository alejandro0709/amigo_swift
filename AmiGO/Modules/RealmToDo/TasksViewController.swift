//
//  TasksTableViewController.swift
//  AmiGO
//
//  Created by Alejandro on 27/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit

class TasksViewController: UIViewController {
    
    fileprivate var mainView: TaskViewControllerView {
        return self.view as! TaskViewControllerView
    }
    
    override func loadView(){
        view = TaskViewControllerView()
    }
    
    override func viewDidLoad() {
        
    }
    
}

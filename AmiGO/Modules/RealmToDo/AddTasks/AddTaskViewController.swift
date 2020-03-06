//
//  AddTaskViewController.swift
//  AmiGO
//
//  Created by Alejandro on 03/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift
import MBProgressHUD
import RxCocoa

class AddTaskViewController: UIViewController {
    var viewModel: AddTaskViewModel?
    var taskId:String?
    var disposeBag = DisposeBag()
    
    private var mainView: AddTaskViewControllerView{
        return self.view as! AddTaskViewControllerView
    }
    
    override func loadView() {
        self.view = AddTaskViewControllerView()
    }
    
    override func viewDidLoad() {
        self.title = "Add Task"
        self.mainView.delegate = self
        setupViewModel()
    }
    
    private func setupViewModel(){
        viewModel = Container.sharedContainer.resolve(AddTaskViewModel.self)
        
        viewModel?.loadTask.observeOn(MainScheduler.instance).subscribe(onNext:{taskResult in
            self.mainView.setupData(taskResult)
            }).disposed(by: disposeBag)
        
        viewModel?.endProcess.subscribe(onNext:{ result in
            MBProgressHUD.hide(for: self.view, animated: true)
            if result {
                self.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
        
        viewModel?.initialize(taskId)
        
        guard let vm = self.viewModel else { return }
        self.mainView.titleTextField.rx.text.orEmpty.bind(to: vm.taskTitle).disposed(by: disposeBag)
        self.mainView.inputTextField.rx.text.orEmpty.bind(to: vm.taskDescription).disposed(by: disposeBag)
//        self.mainView.addButton
        
    }
    
    
}

extension AddTaskViewController: AddTaskViewDelegate{
    func onAddModTaskPressed() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
//        viewModel?.addOrUpdateTask(self.mainView.titleTextField.text, self.mainView.inputTextField.text)
    }
}

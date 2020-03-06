//
//  TaskViewController.swift
//  AmiGO
//
//  Created by Alejandro on 03/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift
import Swinject
import MBProgressHUD

class TaskViewController: UIViewController {
    var viewModel:TaskViewModel?
    var disposeBag = DisposeBag()
    var taskResults: Results<Tasks>!
    private var token: NotificationToken?
    
    fileprivate var mainView: TaskView {
        return self.view as! TaskView
    }
    
    override func loadView() {
        self.view = TaskView()
    }
    
    override func viewDidLoad() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        self.mainView.delegate = self
        setupViewModel()
    }
    
    private func setupViewModel(){
        self.viewModel = Container.sharedContainer.resolve(TaskViewModel.self)
        self.viewModel?.fetch().subscribe(onNext: {result in
            self.taskResults = result
            self.token = self.taskResults.observe{ [weak self] changes in
                guard let collectionView = self?.mainView.tableView else { return }
                switch changes{
                    case .initial:
                        collectionView.reloadData()
                        break
                    case .update(_, let deletions, let insertions, let modifications):
                        collectionView.performBatchUpdates({
                            collectionView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .fade)
                            collectionView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .fade)
                            collectionView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .fade)
                        })
                        break
                    case .error(let error):
                        fatalError("\(error)")
                        break
                }
            }
        }).disposed(by: disposeBag)
        self.viewModel?.goToTaskForm.subscribe(onNext: { observer in
                self.navigateToAddTask(observer)
        }).disposed(by: disposeBag)
        
        self.viewModel?.endProcess.subscribe(onNext:{_ in
            MBProgressHUD.hide(for: self.view, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func navigateToAddTask(_ taskId:String?){
        let rootController = AddTaskViewController()
        rootController.taskId = taskId
        let addTaskNavController = UINavigationController(rootViewController: rootController)
        self.present(addTaskNavController, animated: true)
    }
    
    deinit {
        token?.invalidate()
    }
    
    fileprivate let cellTemplate = TaskUITableViewCell.init()
}

extension TaskViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.tableView.dequeueReusableCell(withIdentifier: TaskUITableViewCell.reuseIdentifier, for: indexPath) as! TaskUITableViewCell
        cell.selectionStyle = .none
        cell.setupData(withTask: taskResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if taskResults.count < indexPath.row {
           return .zero
        }
        if let task = taskResults?[indexPath.row] {
            cellTemplate.setupData(withTask: task)
        }
        return cellTemplate.sizeThatFits(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude)).height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.navigateToUpdateTaskView(self.taskResults[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Get current state from data source
         let actionEdit = UIContextualAction(style: .normal, title: "Edit",
           handler: { (action, view, completionHandler) in
            self.viewModel?.navigateToUpdateTaskView(self.taskResults[indexPath.row])
           completionHandler(true)
         })
        
        let actionDelete = UIContextualAction(style: .normal, title: "Delete",
          handler: { (action, view, completionHandler) in
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.deleteTask(self.taskResults[indexPath.row])
          completionHandler(true)
        })

        actionEdit.backgroundColor = UIColor.principalBlue
        actionDelete.backgroundColor = UIColor.systemRed
         let configuration = UISwipeActionsConfiguration(actions: [actionEdit,actionDelete])
         return configuration
    }
}

extension TaskViewController: TasksViewDelegate{
    func onAddTask() {
        self.viewModel?.navigateToAddTaskView()
    }
}

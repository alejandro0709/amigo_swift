//
//  TaskViewModel.swift
//  AmiGO
//
//  Created by Alejandro on 02/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class TaskViewModel {
    var repository: TaskRepository
    var disposeBag = DisposeBag()
    let goToTaskForm: PublishSubject<String?> = PublishSubject()
    var endProcess: PublishSubject<Bool> = PublishSubject()
//    let taskSelected:PublishSubject<String?> = PublishSubject()
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func fetch() -> Observable<Results<Tasks>>{
        return repository.getAllTasks()
    }
    
    func insertTask(){
        let task = Tasks()
        task.title = "Task Added"
        task.taskDescription = "Small description to this mocked task created"
        self.repository.insertTask(task: task).subscribe { observer in
            switch observer{
            case .error(let error):
                print("AmigoError: \(error)")
            case .completed:
                print("Task saved")
        }
        }.disposed(by: disposeBag)
    }
    
    func navigateToAddTaskView(){
        self.goToTaskForm.onNext(nil)
    }
    
    func navigateToUpdateTaskView(_ task:Tasks){
        self.goToTaskForm.onNext(task.id)
    }
    
    func deleteTask(_ task:Tasks){
        repository.deleteTask(task).subscribe{ observer in
            switch observer{
            case .completed:
                self.endProcess.onNext(true)
                break
            case let .error(error):
                self.endProcess.onError(error)
                break
            }
        }.disposed(by: disposeBag)
    }
}

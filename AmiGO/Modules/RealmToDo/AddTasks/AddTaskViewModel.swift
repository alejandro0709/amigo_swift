//
//  AddTaskViewModel.swift
//  AmiGO
//
//  Created by Alejandro on 04/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddTaskViewModel {
    var repository:TaskRepository
    var loadTask: PublishSubject<Tasks> = PublishSubject()
    var endProcess: PublishSubject<Bool> = PublishSubject()
    var disposableBag = DisposeBag()
    var task: Tasks?
    
    let taskTitle = BehaviorRelay<String>(value: "")
    let taskDescription = BehaviorRelay<String>(value: "")
    
    init(withRepository repository:TaskRepository) {
        self.repository = repository
    }
    
    func initialize(_ taskId:String?){
        if taskId == nil {
            return
        }
        self.repository.fetchTaskById(withId: taskId ?? "").subscribe(onNext:{ taskResult in
            guard let result = taskResult else { return }
            self.task = result
            self.loadTask.onNext(result)
        }).disposed(by: disposableBag)
    }
    
    func addOrUpdateTask(_ title:String, _ taskDescription:String){
        repository.insertOrUpdateTask(withTask: self.task,title, taskDescription).subscribe{ observer in
            switch observer{
                case .completed:
                    self.endProcess.onNext(true)
                    break
            case let .error(error):
                self.endProcess.onError(error)
                break
            }
        }.disposed(by: disposableBag)
    }
    
}

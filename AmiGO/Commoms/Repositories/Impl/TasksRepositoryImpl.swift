//
//  TasksRepositoryImpl.swift
//  AmiGO
//
//  Created by Alejandro on 02/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class TasksRepositoryImpl: TaskRepository {

    var cache:TasksCache!
    
    init(taskCache:TasksCache) {
        self.cache = taskCache
    }
    
    
    func getAllTasks() -> Observable<Results<Tasks>> {
        return cache.tasks()
    }
    
    func insertTask(task: Tasks) -> Completable{
        return self.cache.insertTask(task: task)
    }
    
    func fetchTaskById(withId taskId: String) -> Observable<Tasks?> {
        return self.cache.getTaskById(taskId)
    }
    
    func insertOrUpdateTask(withTask task: Tasks?, _ title: String, _ taskDescription: String) -> Completable {
        return self.cache.insertOrUpdateTask(task, title, taskDescription)
    }
    
    func deleteTask(_ task: Tasks) -> Completable {
        return self.cache.deleteTask(task)
    }
    
    
}

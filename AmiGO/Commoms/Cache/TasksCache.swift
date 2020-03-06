//
//  TasksCache.swift
//  AmiGO
//
//  Created by Alejandro on 02/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class TasksCache {
    
    func tasks() -> Observable<Results<Tasks>>{
        return Observable.create { observer in
            let realm = try! Realm()
            let tasks = realm.objects(Tasks.self)
            observer.onNext(tasks)
            return Disposables.create()
        }
    }
    
    func insertTask(task:Tasks) -> Completable{
        return Completable.create { observer in
        
            let realm: Realm = try! Realm()

            let action: () -> (Void) = {
                var item: Tasks!
                item = realm.object(ofType: Tasks.self, forPrimaryKey: task.id)
                if item == nil {
                    item = realm.create(Tasks.self, value: ["id": task.id])
                }
                item.update(task: task)
                observer(.completed)
            }

            if (realm.isInWriteTransaction) {
                action()
            } else {
                realm.beginWrite()
                action()
                try! realm.commitWrite()
            }
            return Disposables.create()
        }
    }
    
    func getTaskById(_ taskId:String) ->Observable<Tasks?>{
        return Observable.create { observer in
            let realm:Realm = try! Realm()
            let action: () -> Void = {
                let task = realm.object(ofType: Tasks.self, forPrimaryKey: taskId)
                observer.onNext(task)
            }
            
            if (realm.isInWriteTransaction) {
               action()
           } else {
               realm.beginWrite()
               action()
               try! realm.commitWrite()
           }
            
            return Disposables.create()
        }
    }
    
    func insertOrUpdateTask(_ task:Tasks?,_ title:String,_ taskDescription: String) -> Completable {
        if task == nil{
            return insertTask(task: Tasks(value: [title,taskDescription]))
        }
        
        return Completable.create { observer in
            let realm:Realm = try! Realm()
            
            let action: () -> Void = {
                task?.setValue(title, forKey: "title")
                task?.setValue(taskDescription, forKey: "taskDescription")
                observer(.completed)
            }
            
            if (realm.isInWriteTransaction) {
                  action()
              } else {
                  realm.beginWrite()
                  action()
                  try! realm.commitWrite()
              }
            return Disposables.create()
        }
    }
    
    func deleteTask(_ task:Tasks) -> Completable{
        return Completable.create{ observer in
            let realm = try! Realm()
            let action: () -> Void = {
                realm.delete(task)
                observer(.completed)
            }
            
            if realm.isInWriteTransaction {
                action()
            }else {
                realm.beginWrite()
                action()
                try! realm.commitWrite()
            }
            return  Disposables.create()
        }
    }
    
    
    
}

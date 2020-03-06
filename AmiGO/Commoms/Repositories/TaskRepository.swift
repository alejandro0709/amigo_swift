//
//  TaskRepository.swift
//  AmiGO
//
//  Created by Alejandro on 02/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol TaskRepository {
    func getAllTasks() -> Observable<Results<Tasks>>
    
    func insertTask(task: Tasks) -> Completable
    
    func insertOrUpdateTask(withTask task: Tasks?,_ title:String, _ taskDescription:String) -> Completable
    
    func fetchTaskById(withId taskId: String) ->Observable<Tasks?>
    
    func deleteTask(_ task:Tasks) -> Completable
}

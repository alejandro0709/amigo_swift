//
//  Task.swift
//  AmiGO
//
//  Created by Alejandro on 03/03/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RealmSwift


class Tasks: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var taskDescription: String = ""
    @objc dynamic var id = UUID.init().uuidString
    @objc dynamic var created = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func update(task: Tasks){
        self.title = task.title
        self.taskDescription = task.taskDescription
    }

}

//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class DatabaseUtil{
    private var databaseReference:DatabaseReference

    init(databaseReference: DatabaseReference){
        self.databaseReference = databaseReference
    }

    func createLoggedUser(_ data: [String: AnyObject]) {
        let userID = Auth.auth().currentUser!.uid
        let name = Auth.auth().currentUser!.displayName ?? ""
        let user = User(name,data)
        self.insertUser(user,userID)
    }

    private func insertUser(_ user: User, _ userFirebaseId: String) {
        databaseReference.child("user").child(userFirebaseId).setValue(user.toDictionary())
    }

}
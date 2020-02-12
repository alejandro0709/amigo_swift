//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class DatabaseUtil{

    func createLoggedUser(_ data: [String: AnyObject]) {
        let userID = Auth.auth().currentUser!.uid
        let name = Auth.auth().currentUser!.displayName ?? ""
        let user = User(name,data)
        self.insertUser(user,userID)
    }

    private func insertUser(_ user: User, _ userFirebaseId: String) {
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: [userFirebaseId : user.toDictionary()])
    }

}

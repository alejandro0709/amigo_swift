//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import RxSwift

class DatabaseUtil{
    let db = Firestore.firestore()

    func createLoggedUser(_ data: [String: AnyObject]) {
        let userID = Auth.auth().currentUser!.uid
        let name = Auth.auth().currentUser!.displayName ?? ""
        let user = User(name,data)
        self.insertUser(user,userID)
    }

    private func insertUser(_ user: User, _ userFirebaseId: String) {
        
        db.collection("users").addDocument(data: [userFirebaseId : user.toJson()])
    }
    
    func getUser()->Single<User>{
        return Single<User>.create{ observable in
//TODO change with a request to firebase
            observable(.success(User("Lolo",[String:AnyObject]())))
            return Disposables.create()
        }
    }
    
    func updateUserLocation(location: Location){
        print("Location data to update: \(location.toJson())")
//        TODO update user location
    }
    
    func getAllUsers() -> Observable<User>{
        var userList = [User]()
        db.collection("users").getDocuments{ (querySnapshot, err) in
            if let docs = querySnapshot?.documents{
                for docSnapshot in docs{
                    userList.append(User.init(docSnapshot.data()))
                }
            }
        }
        userList = getMockUserList()
        return Observable.of(Observable.from(userList)).merge()
    }
    
    func getMockUserList() -> [User]{
        var userList = [User]()
        userList.append(User.init("User #1", "", Location.init(latitude: 19.4354778, longitude: -99.1364789)))
        userList.append(User.init("User #2", "", Location.init(latitude: 19.4348778, longitude: -99.1364789)))
        userList.append(User.init("User #3", "", Location.init(latitude: 19.4360778, longitude: -99.1364789)))
        userList.append(User.init("User #4", "", Location.init(latitude: 19.4348778, longitude: -99.1370789)))
        userList.append(User.init("User #5", "", Location.init(latitude: 19.4345778, longitude: -99.1371789)))
        userList.append(User.init("User #6", "", Location.init(latitude: 19.4365778, longitude: -99.1362789)))
        return userList
    }


}

//
//  UserProviderImpl.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

class UserProviderImpl: UserProvider {
    
    
    var dbUtil:DatabaseUtil
    
    init(dbUtil:DatabaseUtil){
        self.dbUtil = dbUtil
    }
    
    func getUser() -> Single<User> {
        return dbUtil.getUser()
    }
    
    func getAllUser() -> Observable<User> {
        return self.dbUtil.getAllUsers()
    }
    
    func updateCurrentLocation(location: Location) {
        self.dbUtil.updateUserLocation(location: location)
    }
    
    
}

//
//  UserProvider.swift
//  AmiGO
//
//  Created by Alejandro on 17/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
protocol UserProvider {
    func getUser() -> Single<User>
    
    func updateCurrentLocation(location: Location)
    
    func getAllUser() -> Observable<User>
}

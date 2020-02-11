//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func attemptLogin() -> Completable
}

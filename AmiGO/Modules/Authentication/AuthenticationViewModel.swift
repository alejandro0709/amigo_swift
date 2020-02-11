//
// Created by Alejandro on 08/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import RxSwift

class AuthenticationViewModel {
    let repository: AuthRepository

    let disposeBag = DisposeBag()

    init(repository: AuthRepository) {
        self.repository = repository
    }

    var userLogin = PublishSubject<Any>()

    func attemptLogin() {
        self.userLogin.onNext(true)
    }

    func loginManagerDidComplete(_ result: LoginManagerLoginResult?, _ error: Error?) {
        if error != nil {
            self.userLogin.onError(error!)
            return
        }
        if result?.isCancelled ?? false {
            return
        }

        self.attemptLoginWithFirebase()
    }

    private func attemptLoginWithFirebase() {
        self.repository.attemptLogin().subscribe(onCompleted: {
            self.userLogin.onCompleted()
        }, onError: { error in
            self.userLogin.onError(error)
        }).disposed(by: disposeBag)
    }


}


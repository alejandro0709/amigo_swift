//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift
import FBSDKLoginKit
import FirebaseAuth

class AuthRepositoryImpl: AuthRepository {
    let databaseUtil: DatabaseUtil
    let disposeBag = DisposeBag()

    init(databaseUtil: DatabaseUtil) {
        self.databaseUtil = databaseUtil
    }

    func attemptLogin() -> Completable {
        return Completable.create { observer in
            Observable.zip(self.loginOnFirebase(), self.requestUserInfoFromFacebook()) { (value1, fbUserData) in
                self.databaseUtil.createLoggedUser(fbUserData)
            }.subscribe(onNext: {
                observer(.completed)
            }, onError: { error in
                observer(.error(error))
            }, onCompleted: {
                observer(.completed)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }

    func loginOnFirebase() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }

    func requestUserInfoFromFacebook() -> Observable<[String: AnyObject]> {
        return Observable<[String: AnyObject]>.create { observable in
            let params = ["fields": "id, picture "]
            let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
            let Connection = GraphRequestConnection()
            Connection.add(graphRequest) { (Connection, result, error) in
                if let error = error {
                    observable.onError(error)
                    return
                }
                let info = result as! [String: AnyObject]
                observable.onNext(info)
            }
            Connection.start()
            return Disposables.create()
        }
    }

}

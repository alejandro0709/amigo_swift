//
// Created by Alejandro on 08/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FirebaseAuth
import RxSwift

class AuthenticationViewController: UIViewController {

    let disposeBag = DisposeBag()

    fileprivate var mainView: AuthenticationView {
        return self.view as! AuthenticationView
    }

    public var viewModel: AuthenticationViewModel?

    override func loadView() {
        view = AuthenticationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.delegate = self
        if let accessToken = AccessToken.current {
            print("user is already logged")
        }

        viewModel?.userLogin.subscribe(onNext:{ _ in
            self.loginWithReadPermissions()
        }, onError: { error in
            print("login error: \(error.localizedDescription)")
        },onCompleted: {
            print("navigate to main screen")
        }).disposed(by: disposeBag)

    }


    func loginWithReadPermissions() {
        let loginManager = LoginManager()
        loginManager.logIn(
                permissions: [],
                from: self
        ) { (result, error) -> Void in
            self.viewModel?.loginManagerDidComplete(result, error)
        }
    }


    func logOut() {
        let loginManager = LoginManager()
        loginManager.logOut()
    }

}


extension AuthenticationViewController: FbButtonDelegate {
    func onButtonPressed() {
        self.viewModel?.attemptLogin()
    }


}

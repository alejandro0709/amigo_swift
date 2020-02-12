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

        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }

        viewModel?.userLogin.subscribe(onNext: { _ in
            self.loginWithReadPermissions()
        }, onError: { error in
            print("login error: \(error.localizedDescription)")
        }, onCompleted: {
            self.goMainScreen()
        }).disposed(by: disposeBag)

        viewModel?.initialize()
    }

    private func goMainScreen() {
        let vc = getNextTabNavigationController()
        vc.modalPresentationStyle = .fullScreen
       self.present(vc, animated: true)
    }

    private func getNextTabNavigationController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers =  buildViewControllers()
        tabBarController.tabBar.tintColor = UIColor.init(red: 21/255, green: 30/255, blue: 48/255, alpha: 1)
        tabBarController.tabBar.unselectedItemTintColor = UIColor.init(red: 21/255, green: 30/255, blue: 48/255, alpha: 0.65)
        return tabBarController
    }

    private func buildViewControllers() -> [UIViewController] {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.init(name: "MontserratAlternates-ExtraBold", size: 12)]
        let mapViewController = setupMapViewController(fontAttributes: fontAttributes)
        let profileViewController = setupProfileViewController(fontAttributes: fontAttributes)
        return [mapViewController, profileViewController]
    }

    private func setupProfileViewController(fontAttributes: [NSAttributedString.Key: UIFont?]) -> ProfileViewController {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Icon-user-unselect")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "Icon-user")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        profileViewController.tabBarItem.setTitleTextAttributes(fontAttributes as [NSAttributedString.Key : Any], for: .normal)
        return profileViewController
    }

    private func setupMapViewController(fontAttributes: [NSAttributedString.Key: UIFont?]) -> MapViewController {
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "Icon-map-unselect")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "Icon-map")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        mapViewController.tabBarItem.setTitleTextAttributes(fontAttributes as [NSAttributedString.Key : Any], for: .normal)
        return mapViewController
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


//    func logOut() {
//        let loginManager = LoginManager()
//        loginManager.logOut()
//    }
//
//    func firebaseLogOut(){
//        try! Auth.auth().signOut()
//    }

}


extension AuthenticationViewController: FbButtonDelegate {
    func onButtonPressed() {
        self.viewModel?.attemptLogin()
    }


}

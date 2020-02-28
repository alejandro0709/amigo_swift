//
// Created by Alejandro on 08/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FirebaseAuth
import RxSwift
import Swinject

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

//        for family: String in UIFont.familyNames
//        {
//            print(family)
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
//
//        viewModel?.userLogin.subscribe( onError: { error in
//            print("login error: \(error)")
//        }, onCompleted: {
//            self.goMainScreen()
//        }).disposed(by: disposeBag)
//
//        viewModel?.initialize()
        
        self.goMainScreen()
        
        
        let content = UNMutableNotificationContent()
               content.title = "Late wake up call"
               content.body = "The early bird catches the worm, but the second mouse gets the cheese."
               content.categoryIdentifier = "alarm"
               content.userInfo = ["customData": "fizzbuzz"]
               content.sound = UNNotificationSound.default
        
    

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)

               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request,withCompletionHandler: { error in
            if error != nil{
                print("error \(String(describing: error))")
            }
        })
    }

    private func goMainScreen() {
        let vc = getNextTabNavigationController()
        vc.modalPresentationStyle = .fullScreen
       self.present(vc, animated: true)
    }

    private func getNextTabNavigationController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers =  buildViewControllers()
        tabBarController.tabBar.tintColor = UIColor.darkBlue
        tabBarController.tabBar.unselectedItemTintColor = UIColor.darkBlue.withAlphaComponent(0.65)
        
        let gradient = CAGradientLayer()
        let bounds = tabBarController.tabBar.bounds
        gradient.frame = bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.2).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)

        if let image = getImageFrom(gradientLayer: gradient) {
           tabBarController.tabBar.backgroundImage = image
        }
        
        return tabBarController
    }
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }

    private func buildViewControllers() -> [UIViewController] {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.init(name: "MontserratAlternates-ExtraBold", size: 12)]
        let mapViewController = setupMapViewController(fontAttributes: fontAttributes)
        let profileViewController = setupProfileViewController(fontAttributes: fontAttributes)
        let taskViewController = setupTaskViewController(fontAttributes: fontAttributes)
        return [mapViewController, profileViewController, taskViewController]
    }
    
    private func setupTaskViewController(fontAttributes:[NSAttributedString.Key: UIFont?]) -> TaskViewController {
        let viewController = TaskViewController()
        viewController.tabBarItem = UITabBarItem.init(title: "Tasks", image: nil, tag: 0)
        viewController.tabBarItem.setTitleTextAttributes(fontAttributes as [NSAttributedString.Key : Any], for: .normal)
        return viewController
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
        self.loginWithReadPermissions()
    }


}

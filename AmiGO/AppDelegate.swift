//
//  AppDelegate.swift
//  AmiGO
//
//  Created by Alejandro on 07/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import UIKit
import Swinject
import FBSDKCoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let nav = UINavigationController(rootViewController: getInitialViewController())
        nav.isToolbarHidden = true
        window?.rootViewController = nav
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }

    private func getInitialViewController() -> AuthenticationViewController {
        let authViewController = AuthenticationViewController()
        authViewController.viewModel = Container.sharedContainer.resolve(AuthenticationViewModel.self)
        return authViewController
    }
    

}


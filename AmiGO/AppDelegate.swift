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
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()
    static let geoCoder = CLGeocoder()

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
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
                
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        return true
    }
    

    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey: Any] = [:]
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



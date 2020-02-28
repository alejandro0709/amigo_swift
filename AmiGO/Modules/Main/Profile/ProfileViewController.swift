//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    var viewModel:ProfileViewModel?
    
    let disposeBag = DisposeBag()

    fileprivate var mainView: ProfileView{
        return self.view as! ProfileView
    }

    override func loadView() {
        view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.delegate = self
        self.registerGestureToHideKeyboard()
        self.setupViewModel()
    }
    
    func setupViewModel(){
        self.viewModel = Container.sharedContainer.resolve(ProfileViewModel.self)
        
        self.viewModel?.updateShareLocation.bind(to: self.rx.locationShareUpdate).disposed(by: disposeBag)
        
        self.viewModel?.shareLocationOn.subscribe(onNext: { value in
            self.mainView.shareLocationSwitch.setOn(value, animated: true)
        }).disposed(by: disposeBag)
        
        self.viewModel?.initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mainView.setupVerticalRectGradient()
    }
    
    private func registerGestureToHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProfileViewController: ProfileViewDelegate{
    func onLogoutPressed() {
       print("Logout button was pressed")
    }
    
    func textUserNameDidChange(text: String) {
        print(text)
    }
    
    func shareLocationSwitchChange(value: Bool) {
        self.viewModel?.updateShareLocation(value: value)
    }
}

extension Reactive where Base: UIViewController {
    public var locationShareUpdate: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            UserDefaults.standard.set(active, forKey: "share_location")
        })
    }
}


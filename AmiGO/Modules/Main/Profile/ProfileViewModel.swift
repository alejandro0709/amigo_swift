//
//  ProfileViewModel.swift
//  AmiGO
//
//  Created by Alejandro on 19/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxSwift

class ProfileViewModel {
    public let updateShareLocation: PublishSubject<Bool> = PublishSubject()
    public let shareLocationOn: PublishSubject<Bool> = PublishSubject()
    
    func updateShareLocation(value: Bool){
        updateShareLocation.onNext(value)
    }
    
    func initialize(){
        let shareOn = UserDefaults.standard.bool(forKey: "share_location")
        shareLocationOn.onNext(shareOn)
    }
}

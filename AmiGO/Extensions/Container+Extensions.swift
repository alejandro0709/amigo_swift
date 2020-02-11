//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation
import Swinject
import FirebaseDatabase

extension Container {
    static let sharedContainer: Container = {
        let container = Container()

        container.register(DatabaseUtil.self) { _ in
            let databaseReference = setupDatabaseReference()
            return DatabaseUtil(databaseReference: databaseReference)
        }

        container.register(AuthRepository.self) { resolver in
            let databaseUtil = container.resolve(DatabaseUtil.self)
            return AuthRepositoryImpl(databaseUtil: databaseUtil!)
        }

        container.register(AuthenticationViewModel.self) { _ in
            let repository = container.resolve(AuthRepository.self)
            return AuthenticationViewModel(repository: repository!)
        }

        return container
    }()

    private static func setupDatabaseReference() -> DatabaseReference {
        let databaseInstance = Database.database()
        databaseInstance.isPersistenceEnabled = true
        let databaseReference = databaseInstance.reference()
        databaseReference.keepSynced(true)
        return databaseReference
    }
}
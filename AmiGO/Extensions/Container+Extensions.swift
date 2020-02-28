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
            return DatabaseUtil()
        }

        container.register(AuthRepository.self) { resolver in
            let databaseUtil = container.resolve(DatabaseUtil.self)
            return AuthRepositoryImpl(databaseUtil: databaseUtil!)
        }
        
        container.register(AuthRepository.self) { resolver in
            let databaseUtil = container.resolve(DatabaseUtil.self)
            return AuthRepositoryImpl(databaseUtil: databaseUtil!)
        }

        container.register(AuthenticationViewModel.self) { _ in
            let repository = container.resolve(AuthRepository.self)
            return AuthenticationViewModel(repository: repository!)
        }
        
        container.register(UserProvider.self){ _ in
            let databaseUtil = container.resolve(DatabaseUtil.self)
            return UserProviderImpl(dbUtil: databaseUtil!)
        }
        
        container.register(WeatherProvider.self){_ in
            return WeatherProviderImpl()
        }
        
        container.register(MapRepository.self){ _ in
            let userProvider = container.resolve(UserProvider.self)
            let weatherProvider = container.resolve(WeatherProvider.self)
            return MapRepositoryImpl(userProvider: userProvider!, weatherProvider: weatherProvider!)
        }
        
        container.register(MapViewModel.self) { _ in
            let mapRepository = container.resolve(MapRepository.self)
            return MapViewModel(mapRepository: mapRepository!)
        }
        
        container.register(ProfileViewModel.self){ _ in
            return ProfileViewModel()
        }

        return container
    }()
}

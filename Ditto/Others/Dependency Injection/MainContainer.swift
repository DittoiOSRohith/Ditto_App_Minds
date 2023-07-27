//
//  MainContainer.swift
//  WorkBench
//
//  Created by ketan on 22/08/19.
//  Copyright © 2019 Manzar. All rights reserved.
//

import Foundation
import Swinject

class MainContainer {
    static let sharedContainer = MainContainer()
    let container = Container()
    func setupDefaultContainers() {
        // surya
        //         container.register(DatabaseManager.self, factory: { _ in HTTPNetworking() })
        // Repository
        container.register(RepositoryProtocol.self, factory: { resolver in
            return RepositoryManager(databaseManager: resolver.resolve(DatabaseManager.self)!)
        })
        container.register(BeamSetUpProtocol.self, factory: { _ in BeamSetUpManager() })
        // Mylibrary
        container.register(MyLibraryProtocol.self, factory: { _ in MyLibraryManager() })
        // Login
        container.register(LoginProtocol.self, factory: { _ in LoginManager() })
        container.register(LoginUseCaseProtocol.self, factory: { resolver in
            return LoginUseCaseImplementation(userAuthManager: resolver.resolve(LoginProtocol.self)!)
        })
        container.register(LoginUseCaseInteractorProtocol.self, factory: { resolver in
            return LoginUseCaseInteractorImplementation(requester: resolver.resolve(LoginUseCaseProtocol.self)!)
        })
        // getStarted
        container.register(GetStartedProtocol.self, factory: { _ in GetStartedManager() })
        container.register(GetStartedUseCaseProtocol.self, factory: { resolver in
            return GetStartedImplementation(getStarted: resolver.resolve(GetStartedProtocol.self)!)
        })
        container.register(GetStartedUseCaseInteractorProtocol.self, factory: { resolver in
            return GetStartedUseCaseImplementation(requester: resolver.resolve(GetStartedUseCaseProtocol.self)!)
        })
        // Beamsetup
        container.register(BeamSetUpUseCaseProtocol.self, factory: { resolver in
            return BeamSetUpUseCaseImplementation(beamSetUpProtocol: resolver.resolve(BeamSetUpProtocol.self)!)
        })
        container.register(BeamSetUpUseCaseInteractorProtocol.self, factory: { resolver in
            return BeamSetUpUseCaseInteractorImplementation(requester: resolver.resolve(BeamSetUpUseCaseProtocol.self)!)
        })
        // MyLibrary
        container.register(MyLibraryUseCaseProtocol.self, factory: { resolver in
            return MyLibraryUseCaseImplementation(myLibraryProtocol: resolver.resolve(MyLibraryProtocol.self)!)
        })
        container.register( MyLibraryUseCaseInteractorProtocol.self, factory: { resolver in
            return  MyLibraryUseCaseInteractorImplementation(requester: resolver.resolve( MyLibraryUseCaseProtocol.self)!)
        })
    }
}

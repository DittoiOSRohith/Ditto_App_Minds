//
//  RepositoryManager.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import RxSwift

/* Implementation of Repository Protocol */
struct RepositoryManager: RepositoryProtocol {
    init(databaseManager: DatabaseManager) {
       // self.networkManager = networkManager
    }
    func fetchRequest(params: [String: Any]?, url: String) { // } -> Observable<Data?> {
//        return networkManager.networkRequest(configuration: NetworkServiceConfiguration(path: URL(string: url)!, param: params, method: .get, header: NetworkHeader.createHeader()))
    }
    func updateRequest(params: [String: Any]?, url: String) { // }-> Observable<Data?> {
//        return networkManager.networkRequest(configuration: NetworkServiceConfiguration(path: URL(string: url)!, param: params, method: .post, header: NetworkHeader.createHeader()))
    }
}

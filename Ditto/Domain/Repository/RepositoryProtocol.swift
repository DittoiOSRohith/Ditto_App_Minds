//
//  RepositoryProtocol.swift
//  JoannTraceApp
//
//  Created by Surya Beegam Veliyil Badar on 2020-07-27.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    func fetchRequest(params: [String: Any]?, url: String)  // -> Observable<Data?>
    func updateRequest(params: [String: Any]?, url: String)  // -> Observable<Data?>
}

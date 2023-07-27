//
//  PolicyModel.swift
//  Ditto
//
//  Created by Abiya Joy on 25/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

struct PolicyModel: Codable {
    var vVal = String()
    var type = String()
    var id = String()
    var name = String()
    var policyContent = String()
    enum CodingKeys: String, CodingKey {
        case vVal = "_v"
        case type = "_type"
        case id = "id"
        case name = "name"
        case policyContent = "c_body"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.vVal = try values.decodeIfPresent(String.self, forKey: .vVal) ?? FormatsString.emptyString
        self.type = try values.decodeIfPresent(String.self, forKey: .type) ?? FormatsString.emptyString
        self.id = try values.decodeIfPresent(String.self, forKey: .id) ?? FormatsString.emptyString
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? FormatsString.emptyString
        self.policyContent = try values.decodeIfPresent(String.self, forKey: .policyContent) ?? FormatsString.emptyString
    }
}

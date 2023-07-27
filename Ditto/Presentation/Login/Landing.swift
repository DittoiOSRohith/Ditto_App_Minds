//
//  Landing.swift
//  Ditto
//
//  Created by Abiya Joy on 16/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

struct Landing: Codable {
    var vVal = String()
    var type = String()
    var idVal = String()
    var name = String()
    var landingContent: LandingContent?
    enum CodingKeys: String, CodingKey {
        case vVal = "_v"
        case type = "_type"
        case idVal = "id"
        case name = "name"
        case landingContent = "c_body"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.vVal = try values.decodeIfPresent(String.self, forKey: .vVal) ?? FormatsString.emptyString
        self.type = try values.decodeIfPresent(String.self, forKey: .type) ?? FormatsString.emptyString
        self.idVal = try values.decodeIfPresent(String.self, forKey: .idVal) ?? FormatsString.emptyString
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? FormatsString.emptyString
        self.landingContent = try values.decodeIfPresent(LandingContent.self, forKey: .landingContent)
    }
}

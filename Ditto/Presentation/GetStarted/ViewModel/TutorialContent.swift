//
//  TutorialContent.swift
//  Ditto
//
//  Created by Shefrin Hakeem on 11/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

struct TutorialContent: Codable {
    let onboardingg: [Onboarding]?
    enum CodingKeys: String, CodingKey {
        case onboardingg = "onboarding"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.onboardingg = try values.decodeIfPresent([Onboarding].self, forKey: .onboardingg)
    }
}

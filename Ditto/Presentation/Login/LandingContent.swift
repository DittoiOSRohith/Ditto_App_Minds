//
//  LandingContent.swift
//  Ditto
//
//  Created by Abiya Joy on 16/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

struct LandingContent: Codable {
    var customerCareEmaill = String()
    var customerCareePhonee = String()
    var customerCareeTimingg = String()
    var videoUrll = String()
    var imageUrll = String()
    enum CodingKeys: String, CodingKey {
        case customerCareEmaill = "customerCareEmail"
        case customerCareePhonee = "customerCareePhone"
        case customerCareeTimingg = "customerCareeTiming"
        case videoUrll = "videoUrl"
        case imageUrll = "imageUrl"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.customerCareEmaill = try values.decodeIfPresent(String.self, forKey: .customerCareEmaill) ?? FormatsString.emptyString
        self.customerCareePhonee = try values.decodeIfPresent(String.self, forKey: .customerCareePhonee) ?? FormatsString.emptyString
        self.customerCareeTimingg = try values.decodeIfPresent(String.self, forKey: .customerCareeTimingg) ?? FormatsString.emptyString
        self.videoUrll = try values.decodeIfPresent(String.self, forKey: .videoUrll) ?? FormatsString.emptyString
        self.imageUrll = try values.decodeIfPresent(String.self, forKey: .imageUrll) ?? FormatsString.emptyString
    }
}

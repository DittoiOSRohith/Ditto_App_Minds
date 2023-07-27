//
//  TutorialContent.swift
//  Ditto
//
//  Created by Shefrin Hakeem on 11/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

struct InstructionItem: Codable {
    var idd = Int()
    var titlee = String()
    var descriptionn = String()
    var imagePathh = String()
    var videoPathh = String()
    var instructionss = [InstructionItem]()
    var tutorialPdfUrll = String()
    enum CodingKeys: String, CodingKey {
        case idd = "id"
        case titlee = "title"
        case descriptionn = "description"
        case imagePathh = "imagePath"
        case videoPathh = "videoPath"
        case instructionss = "instructions"
        case tutorialPdfUrll = "tutorialPdfUrl"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.idd = try values.decodeIfPresent(Int.self, forKey: .idd) ?? 1
        self.titlee = try values.decodeIfPresent(String.self, forKey: .titlee) ?? FormatsString.emptyString
        self.descriptionn = try values.decodeIfPresent(String.self, forKey: .descriptionn) ?? FormatsString.emptyString
        self.imagePathh = try values.decodeIfPresent(String.self, forKey: .imagePathh) ?? FormatsString.emptyString
        self.videoPathh = try values.decodeIfPresent(String.self, forKey: .videoPathh) ?? FormatsString.emptyString
        self.instructionss = try values.decodeIfPresent([InstructionItem].self, forKey: .instructionss) ?? []
        self.tutorialPdfUrll = try values.decodeIfPresent(String.self, forKey: .tutorialPdfUrll) ?? FormatsString.emptyString
    }

}

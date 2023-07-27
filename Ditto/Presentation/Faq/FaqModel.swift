//
//  FaqModel.swift
//  Ditto
//
//  Created by Gaurav Rajan on 18/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class FaqModel: NSObject {
    var question = String()
    var answer = String()
    var videoPath = String()
    var webLinkUrl = String()
    var arrSubAnswer = [SubAnswerModel]()
    func setData(dictData: [String: AnyObject]) {
        self.question = dictData["Ques"] as? String ?? FormatsString.emptyString
        self.answer = dictData["Answ"] as? String ?? FormatsString.emptyString
        self.videoPath = dictData["video_url"] as? String ?? FormatsString.emptyString
        self.webLinkUrl = dictData["web_url"] as? String ?? FormatsString.emptyString
        if let arrSubAnswer = dictData["SubAnsw"] as? [[String: AnyObject]] {
            for dict in arrSubAnswer {
                let objSubAnswerModel = SubAnswerModel()
                objSubAnswerModel.setData( dictData: dict)
                self.arrSubAnswer.append(objSubAnswerModel)
            }
        }
    }
}

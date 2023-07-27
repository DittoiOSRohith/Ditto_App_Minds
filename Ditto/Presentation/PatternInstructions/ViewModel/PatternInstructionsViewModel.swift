//
//  PatternInstructionsViewModel.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 15/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation
import UIKit.UIImage

class PatternInstructionsViewModel {
    // MARK: VARIABLE DECLARATION
    var patternPDFPath = FormatsString.emptyString
    var fromPatternDescription = false
    var fromSewingInstruction = false
    var fromTutorial = false
    var fileURL: URL!
    var mainURL = String()
    var titleLable = String()
    var isPresentedFromWorkSpace = false
    //MARK: FUNCTION LOGICS 
    func disappearFunction() {  // Pdf button crash fix logic
       WorkspaceBaseViewController.workspaceViewModel.isFromInstructionView = !fromPatternDescription ? true : false
    }
    func loadPDFPath() -> URL? {   // Function to load PDF
        if self.fromSewingInstruction || self.fromPatternDescription || self.fromTutorial {
            guard let path = self.fileURL else {
                return nil
             }
            return path
        } else {
            guard let path = Bundle.main.url(forResource: "\(self.patternPDFPath)", withExtension: "pdf") else {
                return nil }
            return path
        }
    }
}

//
//  Ext+WSBVC+UITextViewDelegates.swift
//  Ditto
//
//  Created by Gokul Ramesh on 30/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

extension AddNotesViewController: UITextViewDelegate {
    //MARK: Textview delegate functions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        newText = newText.replacingOccurrences(of: "\n", with: "")
        let numberOfChars = newText.count
        self.numberOfLetters = numberOfChars
        print("The Number of Character => \(numberOfChars)")
        return numberOfChars <= numberOfQuickNotesWords    // 500 Limit Value
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == FormatsString.EnterYourNotes {
            textView.text = FormatsString.emptyString
            textView.textColor = AppColor.needleGrey
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == FormatsString.emptyString {
            self.setPlaceHolder()
        }
    }
}

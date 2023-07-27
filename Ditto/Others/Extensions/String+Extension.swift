//
//  String+Extension.swift
//  WorkBench
//
//  Created by Infosys  on 04/10/19.
//  Copyright © 2019 Infosys. All rights reserved.
//

import UIKit

extension String {
    func underlineText() -> NSMutableAttributedString { // TRAC_506_LANDINGUX
        let color = CustomColor.signIn
        let size: CGFloat = UIDevice.isPhone ? 14 : 22
        let font = CustomFont.avenirLtProDemi(size: size)
        let rangeToUnderLine = NSRange(location: 0, length: self.count)
        let underLineTxt = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: font ?? UIFont.boldSystemFont(ofSize: size), NSAttributedString.Key.foregroundColor: color])
        underLineTxt.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeToUnderLine)
        return underLineTxt
    }
    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
    func isValidEmail() -> Bool {
        let emailRegEx = FormatsString.emailFormatString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func isValidPassword() -> Bool {
        return self.count >= 6
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? FormatsString.emptyString
    }
    func getStringValueRemovingSpecialCharacter() -> String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: " ")
    }
    var youtubeID: String? {
        let pattern = FormatsString.youtubeIDPattern
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        return (self as NSString).substring(with: result.range)
    }
}

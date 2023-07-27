//
//  CustomerSupportCell.swift
//  Ditto
//
//  Created by Neb Shaw on 5/10/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class CustomerSupportCell: UICollectionViewCell {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle1: UILabel!
    @IBOutlet weak var subTitle2: UILabel!
    @IBOutlet weak var describe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        if self.title.text == FormatsString.emailLabel {
            let mailSize =  UIDevice.isPad ? CGFloat(18) : CGFloat(14)
            if let strNumber: NSString = self.describe.text as NSString? {
                let range = (strNumber).range(of: CommonConst.customerCareEmailText)
                let attribute = NSMutableAttributedString.init(string: strNumber as String)
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: CustomColor.signIn, range: range)
                attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                attribute.addAttribute(.font, value: CustomFont.avenirLtProDemi(size: mailSize) ?? UIFont.systemFont(ofSize: mailSize), range: range)
                self.describe.attributedText = attribute
            }
        } else {
            if let strNumber: NSString = self.subTitle2.text as NSString? {
                let attribute = NSMutableAttributedString.init(string: strNumber as String)
                attribute.addAttribute(.font, value: CustomFont.avenirLtProDemi(size: 8) ?? UIFont.systemFont(ofSize: 8), range: (strNumber).range(of: "\n\n"))
                attribute.addAttribute(.font, value: CustomFont.avenirLtProDemi(size: 24) ?? UIFont.systemFont(ofSize: 24), range: (strNumber).range(of: CommonConst.customerCareePhoneText))
                self.subTitle2.attributedText = attribute
            }
        }
    }
}

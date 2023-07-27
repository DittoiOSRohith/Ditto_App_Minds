//
//  CustomerSupportCollectionViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension CustomerSupportViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Collection view functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.customerSupportViewModel.customerSupportObjAry.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            if self.touchFlag {
                return
            }
            self.touchFlag = true
            self.didselectActions(index: indexPath.row)
        }
    }
    func didselectActions(index: Int) {
        if index == 0 {   // Open email application from App
            guard let appURL = URL(string: ApiUrlStrings.emailOpenURL) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:]) { status in
                    if status {
                        self.touchFlag = false
                    }
                }
            } else {
                UIApplication.shared.open(appURL) { status in
                    if status {
                        self.touchFlag = false
                    }
                }
            }
        } else if index == 1 {   // Open phone dialer from App
            guard let number = URL(string: ApiUrlStrings.callDialerOpenURL) else { return }
            UIApplication.shared.open(number) { status in
                if status {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.touchFlag = false
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.customerSupportCellIdentifier, for: indexPath) as? CustomerSupportCell {
            cell.isMultipleTouchEnabled = false
            let dictData = self.customerSupportViewModel.customerSupportObjAry
            if indexPath.row < dictData.count && indexPath.row >= 0 {
                cell.layoutIfNeeded()
                cell.imageIcon.image = UIImage(named: dictData[indexPath.row].iconImage)
                cell.title.text = dictData[indexPath.row].title
                cell.subTitle1.text = dictData[indexPath.row].subtitle1
                cell.subTitle2.text = dictData[indexPath.row].subtitle2
                cell.describe.text = dictData[indexPath.row].describe
                cell.addShadow()
                let mailSize = UIDevice.isPad ? CGFloat(18) : CGFloat(14)
                let strNumber: NSString = dictData[indexPath.row].describe as NSString
                let range = (strNumber).range(of: "\(CommonConst.customerCareEmailText)")
                let attribute = NSMutableAttributedString.init(string: strNumber as String)
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: CustomColor.signIn, range: range)
                attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                attribute.addAttribute(.font, value: CustomFont.avenirLtProDemi(size: mailSize) ?? UIFont.systemFont(ofSize: mailSize), range: range)
                cell.describe.attributedText = attribute
                if indexPath.row == 1 {
                    if let strNumber: NSString = cell.subTitle2.text as NSString? {
                        let attribute = NSMutableAttributedString.init(string: strNumber as String)
                        attribute.addAttribute(.font, value: CustomFont.avenirLtProDemi(size: 8) ?? UIFont.systemFont(ofSize: 8), range: (strNumber).range(of: "\n\n"))
                        attribute.addAttribute(.font, value: CustomFont.avenirLtProDemi(size: 24) ?? UIFont.systemFont(ofSize: 24), range: (strNumber).range(of: CommonConst.customerCareePhoneText))
                        cell.subTitle2.attributedText = attribute
                    }
                }
                collectionViewCell = cell
            }
        }
        return collectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellAcross = self.customerSupportViewModel.cellsAcross
        let spaceBetweenCells = self.customerSupportViewModel.spaceBetweenCells
        let inset = self.customerSupportViewModel.insetValues
        let wdth = collectionView.bounds.width / cellAcross - spaceBetweenCells - (inset)
        let hte = collectionView.bounds.height - (2 * inset)
        return CGSize(width: wdth, height: hte)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = self.customerSupportViewModel.insetValues
        return UIEdgeInsets(top: inset, left: 5, bottom: inset, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.customerSupportViewModel.spaceBetweenCells
    }
}

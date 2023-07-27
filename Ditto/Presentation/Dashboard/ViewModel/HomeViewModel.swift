//
//  HomeViewModel.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 26/03/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit.UIImage
import CoreData
import Alamofire

class HomeViewModel {
    //MARK: VARIABLE DECLARATION
    var workspace: Workspace?
    let cellsAcross: CGFloat = 3
    let spaceBetweenCells: CGFloat = 50
    let insetValues: CGFloat = 10
    var firstName = String()
    var welcomeMessage = String()
    var isinHomeScreen: Bool = false
    var offlineDataArray = [MyLibraryPatterns]()
    var trailPatternArray = [PatternModelObject]()
    var tailornovaService = TailornovaApiService()
    var homeObjectsArray = [HomeObject(iconImage: HomeTileIconImage.libraryImage, titleText: HomeTileTitleText.libraryTitle, text: HomeTileTitleText.libraryText), HomeObject(iconImage: HomeTileIconImage.tutorialImage, titleText: HomeTileTitleText.tutorialTitle, text: HomeTileTitleText.tutorialText), HomeObject(iconImage: HomeTileIconImage.dittoPatternsImage, titleText: HomeTileTitleText.dittoPatternsTitle, text: HomeTileTitleText.dittoPatternsText), HomeObject(iconImage: HomeTileIconImage.joannImage, titleText: HomeTileTitleText.joannTitle, text: HomeTileTitleText.joannText)]
    var objMyLibraryModel = MyLibraryData()
    //MARK: FUNCTION LOGICS
    func getHomeScreenTitles() -> NSMutableAttributedString {  // Displaying welcome heading and other labels in homescreen with different size and fonts
        let size: CGFloat = UIDevice.isPhone ? 24 : 48
        let font1 = CustomFont.avenirLtProBold(size: size)
        var font2 = CustomFont.avenirLtProRegular(size: size)
        let combination = NSMutableAttributedString()
        self.firstName = CommonConst.guestUserCheck ? FormatsString.emptyString : CommonConst.firstNameValue
        self.welcomeMessage = CommonConst.guestUserCheck ? FormatsString.HiThere : FormatsString.WelcomeBack
        font2 = CommonConst.guestUserCheck ? font1 : font2
        combination.append(NSMutableAttributedString(string: self.welcomeMessage, attributes: [NSAttributedString.Key.font: font2 ?? UIFont.systemFont(ofSize: size)]))
        let name = NSMutableAttributedString(string: self.firstName.capitalized, attributes: [NSAttributedString.Key.font: font1 ?? UIFont.systemFont(ofSize: size)])
        combination.append(name)
        return combination
    }
    func titleFunction(ind: Int) -> String {  // Getting title of each tile
        return ind == 3 ? FormatsString.shopJoann : (ind == 2 ? FormatsString.buyPatterns : FormatsString.emptyString)
    }
    func messageFunction(ind: Int) -> String {   // Getting message of each tile
        return ind == 3 ? MessageString.shopForMaterials : (ind == 2 ? MessageString.stayTuned : FormatsString.emptyString)
    }
    func cellOfCollectionView(index: Int, cell: HomeScreenCollectionViewCell) -> HomeScreenCollectionViewCell {  // Getting data for entries in each tile
        let size: CGFloat = UIDevice.isPhone ? 14 : 22
        let font = CustomFont.avenirLtProRegular(size: size)
        cell.backgroungImageView.image = UIImage(named: self.homeObjectsArray[index].iconImage)
        let strr1 = self.homeObjectsArray[index].text
        var str2 = self.homeObjectsArray[index].titleText
        if index == 0 {
            var patternCount = String()
            if let manager = NetworkReachabilityManager(), !manager.isReachable {
                patternCount = !CommonConst.guestUserCheck ? "\(self.offlineDataArray.count)" : "\(self.objMyLibraryModel.totalPatternCount)"
            } else {
                patternCount = !CommonConst.guestUserCheck ? CommonConst.myLibPatternCount == "\(self.objMyLibraryModel.totalPatternCount)" ? "\(self.objMyLibraryModel.totalPatternCount)" : CommonConst.myLibPatternCount : "\(self.objMyLibraryModel.totalPatternCount)"
            }
            str2 = patternCount != FormatsString.zeroLabel || CommonConst.guestUserCheck ? "\(FormatsString.browseLabel) \(patternCount) \(FormatsString.libraryTileLabel)" : "\(FormatsString.browseLabel) \(FormatsString.libraryTileLabel)"
        }
        let combination = NSMutableAttributedString()
        combination.append(NSMutableAttributedString(string: strr1, attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: size )]))
        cell.infotextLabel.attributedText =  combination
        cell.infotextSubLabel.attributedText = str2.underlineText()
        cell.infotextSubLabel.textColor = (index == 0 || index == 3) ? UIColor.white : AppColor.needleGrey
        cell.patternLibView.isHidden = true
        cell.cellfrontView.isHidden = true
        cell.cellfrontView.addShadow()
        return cell
    }
    func getMyLibraryData(pageID: String = FormatsString.oneLabel, completion: @escaping (_ ResponseDict: MyLibraryData) -> Void) { // My Library API call
        let paramDict = ["OrderFilter": ["purchasedPattern": MyLibraryAttribute.purchasedPattern, "subscriptionList": MyLibraryAttribute.subscriptionList, "allQuery": MyLibraryAttribute.allQuery, "trialPattern": MyLibraryAttribute.trialPattern, "emailID": "\(CommonConst.loginEmailText)"], "pageId": "\(pageID)", "patternsPerPage": FormatsString.patternsPerPageCount, "searchTerm": FormatsString.emptyString, "ProductFilter": []] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: "\(Apis.MyLibraryURL)", params: paramDict as Dictionary) { (response) in
            if let responseData = response {
                if responseData.success {
                    if let dictData = responseData.data {
                        let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                        if error.isEmpty {
                            if !self.objMyLibraryModel.prod.isEmpty {
                                self.objMyLibraryModel.prod.removeAll()
                            }
                            self.objMyLibraryModel.setMyLibraryData(dictData: dictData)
                        }
                    }
                } else {
                    self.objMyLibraryModel.setMyLibraryData(dictData: [String: AnyObject]())
                }
            }
            completion(self.objMyLibraryModel)
            UserDefaults.standard.removeObject(forKey: CommonConst.SelectedFilterObjectss)
        }
    }
}

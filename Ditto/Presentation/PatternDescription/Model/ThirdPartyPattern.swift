//
//  ThirdPartyPattern.swift
//  Ditto
//
//  Created by Gokul Ramesh on 01/12/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation

// MARK: - Welcome
class ThirdPartyPatternWelcome {
    var action = String()
    var queryString = String()
    var locale = String()
    var product: ThirdPartyPatternProduct?
    func setWelcomeData(dictData: [String: AnyObject]) {
        self.action = dictData["action"] as? String ?? FormatsString.emptyString
        self.queryString = dictData["queryString"] as? String ?? FormatsString.emptyString
        self.locale = dictData["locale"] as? String ?? FormatsString.emptyString
        if let objproduct = dictData["product"] as? [String: AnyObject] {
            let objThirdPartyPatternProduct = ThirdPartyPatternProduct()
            objThirdPartyPatternProduct.setProductData(dictData: objproduct)
            self.product = objThirdPartyPatternProduct
        }
    }
}

// MARK: - Product
class ThirdPartyPatternProduct {
    var brandVariantData: ThirdPartyPatternBrandVariant?
    func setProductData(dictData: [String: AnyObject]) {
        if let objvariation = dictData["brandVariantData"] as? [String: AnyObject] {
            let objbrandVariantData = ThirdPartyPatternBrandVariant()
            objbrandVariantData.setBrandVariantData(dictData: objvariation)
            self.brandVariantData = objbrandVariantData
        }
    }
}

// MARK: - BrandVariantData
class ThirdPartyPatternBrandVariant {
    var variation = [ThirdPartyPatternVariation]()
    func setBrandVariantData(dictData: [String: AnyObject]) {
        if let objvariation = dictData["variation"] as? [AnyObject] {
            for variation in objvariation {
                let variation = variation as? [String: AnyObject] ?? [: ]
                let objThirdPartyPatternVariation = ThirdPartyPatternVariation()
                objThirdPartyPatternVariation.setVariationData(dictData: variation)
                self.variation.append(objThirdPartyPatternVariation)
            }
        }
    }
}

// MARK: - Variation
class ThirdPartyPatternVariation {
    var size = [ThirdPartyPatternSize]()
    var style = String()
    var styleName = String()
    func setVariationData(dictData: [String: AnyObject]) {
        self.style = dictData["style"] as? String ?? FormatsString.emptyString
        self.styleName = dictData["styleName"] as? String ?? FormatsString.emptyString
        if let sizeArr = dictData["size"] as? [AnyObject] {
            for obj in sizeArr {
                let obj = obj as? [String: AnyObject] ?? [: ]
                let objThirdPartyPatternSize = ThirdPartyPatternSize()
                objThirdPartyPatternSize.setSizeData(dictData: obj)
                self.size.append(objThirdPartyPatternSize)
            }
        }
    }
}

// MARK: - Size
class ThirdPartyPatternSize {
    var size = String()
    var designID = String()
    var mannequinID = String()
    func setSizeData(dictData: [String: AnyObject]) {
        self.size = dictData["size"] as? String ?? FormatsString.emptyString
        self.designID = dictData["designID"] as? String ?? FormatsString.emptyString
        self.mannequinID = dictData["mannequinID"] as? String ?? FormatsString.emptyString
    }
}

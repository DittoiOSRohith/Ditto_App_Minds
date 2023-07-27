//
//  CustomerSupportViewModel.swift
//  Ditto
//
//  Created by Neb Shaw on 5/10/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit.UIImage

class CustomerSupportViewModel {
    // MARK: VARIABLE DECLARATION
    var workspace: Workspace?
    let cellsAcross: CGFloat = 2
    var spaceBetweenCells: CGFloat = 0
    let insetValues: CGFloat = 10
    var customerSupportObjAry = [CustomerSupportObj(iconImage: ImageNames.mailImage, title: FormatsString.emailLabel, subtitle1: FormatsString.emailSubTitleOneLabel, subtitle2: FormatsString.emailSubTitleTwoLabel, describe: FormatsString.emailDescriptionLabel), CustomerSupportObj(iconImage: ImageNames.callImage, title: FormatsString.phoneLabel, subtitle1: FormatsString.phoneSubTitleOneLabel, subtitle2: FormatsString.phoneSubTitleTwoLabel, describe: CommonConst.customerCareeTimingText)]
}

//
//  Ext+ButtomVisibilityDelegate.swift
//  Ditto
//
//  Created by abiya.joy on 06/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController: ButtonVisibilityDelegate {
    func layoutButtonValueSetting() {   // Reference layout fabric length selection
        let arrayToPass = self.objNewWorkSpaceBaseViewModel.getSelvagesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
        if arrayToPass.isEmpty {
            self.objNewWorkSpaceBaseViewModel.selected = FormatsString.emptyString
        } else if arrayToPass.count == 1 {
            let buttonOne = (self.patternsSegmentedContol.selectedSegmentIndex != 2) ? ReferenceLayoutType.fourtyfive : ReferenceLayoutType.twenty
            let buttonTwo = (self.patternsSegmentedContol.selectedSegmentIndex != 2) ? ReferenceLayoutType.sixty : ReferenceLayoutType.fourtyfive
            if arrayToPass[0].fabricLength == buttonOne {
                self.objNewWorkSpaceBaseViewModel.selected = ReferenceLayoutType.fourtyfive
            } else if arrayToPass[0].fabricLength == buttonTwo {
                self.objNewWorkSpaceBaseViewModel.selected = ReferenceLayoutType.sixty
            }
        } else if arrayToPass.count == 2 {
            self.objNewWorkSpaceBaseViewModel.selected = ReferenceLayoutType.fourtyfive
        }
        self.layoutButtonHandling()
    }
    func segmentDidPress() {   // Pattern Segment tap
        self.objNewWorkSpaceBaseViewModel.isSelectAll = false
        self.patternsView.patternCollectionView?.contentOffset = CGPoint(x: 0, y: 0)
        self.patternsView.patternsLeftArrow?.isEnabled = false
        self.patternsView.patternsRightArrow?.isEnabled = true
        CommonConst.userDefault.setValue(self.patternPiecesButton.isSelected,
                                         forKey: "selectedTab\(self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory)")
        self.saveLocalWS()
        if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.garment.rawValue { // 0 {
            self.objNewWorkSpaceBaseViewModel.selectedTabCategory = WorkAreaTabCategory.garment.categoryName // "Garment"
            self.showAlertOnSwitchingTabs(tabCategory: WorkAreaTabCategory.garment.categoryName)
        } else if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.lining.rawValue {  // 1 {
            self.objNewWorkSpaceBaseViewModel.selectedTabCategory = WorkAreaTabCategory.lining.categoryName // "Lining"
            self.showAlertOnSwitchingTabs(tabCategory: WorkAreaTabCategory.lining.categoryName) // "Lining")
        } else if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.interfacing.rawValue {
            self.objNewWorkSpaceBaseViewModel.selectedTabCategory = WorkAreaTabCategory.interfacing.categoryName // "Interfacing"
            self.showAlertOnSwitchingTabs(tabCategory: WorkAreaTabCategory.interfacing.categoryName) // "Other")
        } else if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.other.rawValue {
            self.objNewWorkSpaceBaseViewModel.selectedTabCategory = WorkAreaTabCategory.other.categoryName // "Other"
            self.showAlertOnSwitchingTabs(tabCategory: WorkAreaTabCategory.other.categoryName) // "Other")
        }
        self.layoutButtonHandling()
    }
    func layoutButtonHandling() {   // handling text of fabric length button in refernce layout based on tab category
        self.workspaceSpliceReferenceView.fourtyFiveLabel.text = (self.patternsSegmentedContol.selectedSegmentIndex != 2) ? "\(ReferenceLayoutType.fourtyfive)\"" : "\(ReferenceLayoutType.twenty)\""
        self.workspaceSpliceReferenceView.sixtyLable.text = (self.patternsSegmentedContol.selectedSegmentIndex != 2) ? "\(ReferenceLayoutType.sixty)\"" : "\(ReferenceLayoutType.fourtyfive)\""
        self.workspaceSpliceReferenceView.fourtyFiveNapLabel.text = (self.patternsSegmentedContol.selectedSegmentIndex != 2) ? ReferenceLayoutType.napLabel : FormatsString.emptyString
        self.workspaceSpliceReferenceView.sixtyNapLabel.text = (self.patternsSegmentedContol.selectedSegmentIndex != 2) ? ReferenceLayoutType.napLabel : FormatsString.emptyString
    }
}

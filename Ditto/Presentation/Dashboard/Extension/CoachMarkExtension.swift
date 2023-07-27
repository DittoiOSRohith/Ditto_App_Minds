//
//  CoachMarkExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension HomeViewController {
    // CoachMark Stuffs
    func setCoachmark() {
        if CommonConst.showCoachMarkCheck {
            self.displayCoachMarkVC()
            CommonConst.showCoachMarkCheck = false
        } else {
            if CommonConst.coackmarkCompleteStatusCheck {
                self.displayCoachMarkVC()
            }
        }
    }
    func displayCoachMarkVC() {
        if let coachMarkVC = Constants.dashBoardStoryBoard.instantiateViewController(identifier: Constants.CoachMarkViewControllerIdentifier) as? CoachMarkViewController {
            self.navigationController?.pushViewController(coachMarkVC, animated: false)
        }
    }
}

//
//  Ext+WSBVC+ScrollDelegate.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.objNewWorkSpaceBaseViewModel.imagvPopUp
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.objNewWorkSpaceBaseViewModel.imagvPopUp
    }
}

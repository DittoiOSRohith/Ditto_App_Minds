//
//  HowToScrollViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension HowToViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.view.viewWithTag(TagValue.scrollTag) == nil {
            self.currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.objHowToViewModel.imagvPopUp
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.objHowToViewModel.imagvPopUp
    }
}

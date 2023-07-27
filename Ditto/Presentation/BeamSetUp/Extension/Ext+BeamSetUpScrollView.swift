//
//  Ext+BeamSetUpScrollView.swift
//  Ditto
//
//  Created by Gokul Ramesh on 24/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

extension BeamSetUpViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.view.viewWithTag(TagValue.scrollTag) == nil {
            self.currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup {
                self.beamSetUpViewModel.typeofScreen = TutorialDataFetchType.beamSetup
                let inst = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup {
            self.beamSetUpViewModel.beamCurrentIndex = self.pageControl.currentPage
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.beamSetUpViewModel.imagvPopUp
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.beamSetUpViewModel.imagvPopUp
    }
    func moveToPage(_ page: Int, animated: Bool) {   // Screen scroll to previous and next logic
        if page < 0 || page >= self.collectionView.numberOfItems(inSection: 0) {
            return
        }
        self.currentIndex = page
        if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup {
            self.beamSetUpViewModel.typeofScreen = TutorialDataFetchType.beamSetup
            let inst = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
            if page == inst.count - 1 && self.beamSetUpViewModel.selectedIndex == FormatsString.oneLabel {
                self.beamSetUpViewModel.beamCurrentIndex = currentIndex
            }
        }
        self.collectionView.isPagingEnabled = false
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
        self.collectionView.isPagingEnabled = true
    }
}


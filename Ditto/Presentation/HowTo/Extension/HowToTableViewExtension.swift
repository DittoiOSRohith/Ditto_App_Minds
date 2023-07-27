//
//  HowToTableViewExtension.swift
//  Ditto
//
//  Created by Abiya Joy on 28/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension HowToViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Collection view functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.objHowToViewModel.setUpcollectionView {
            return self.objHowToViewModel.getArrayForSelectedIndex(selectedTabIndex: self.getApiIndex(index: "\(self.objHowToViewModel.selectedIndex)"), type: TutorialDataFetchType.howTo).count
        } else if collectionView == self.segmentCollectionView {
            return self.objHowToViewModel.tabTitles.count
        }
        return 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if collectionView == self.objHowToViewModel.setUpcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.beamsetupCellIdentifier, for: indexPath) as? BeamSetUpCollectionViewCell
            let instruction = self.objHowToViewModel.getArrayForSelectedIndex(selectedTabIndex: "\(self.getApiIndex(index: "\(self.objHowToViewModel.selectedIndex)"))", type: TutorialDataFetchType.howTo)
            if indexPath.row < instruction.count && indexPath.row >= 0 {
                cell!.beamSetUpView.isHidden = true
                cell!.backgroundColor = .clear
                cell!.workSpaceHowToView.instructionTitleHeight.constant = 37
                cell!.workSpaceHowToView.isHidden = false
                objHowToViewModel.resourceName = instruction[indexPath.row].instructionVideoPath!
                cell!.workSpaceHowToView.instructionTitle.isHidden = true
                cell!.workSpaceHowToView.instructionTitleHeight.constant = 0
                cell!.workSpaceHowToView.instructionLabel.scrollRangeToVisible(NSRange(location: 0, length: 0))
                cell!.workSpaceHowToView.instructionLabel.text = instruction[indexPath.row].instructionDescription
                DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(250))) {
                    cell!.workSpaceHowToView.instructionLabel.flashScrollIndicators()
                }
                cell!.workSpaceHowToView.instructionImageView.isUserInteractionEnabled = true
                let url = URL(string: instruction[indexPath.row].instructionImage!)
                cell!.workSpaceHowToView.instructionImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, error, _, _) in
                    cell!.workSpaceHowToView.instructionImageView.image = (error == nil) ? image : UIImage(named: ImageNames.placeholderImage)
                }
                cell!.workSpaceHowToView.watchVideoButton.isHidden = false
                cell!.workSpaceHowToView.playButton.isHidden = false
                cell!.workSpaceHowToView.watchVideoButton.addTarget(self, action: #selector(watchVideoButtonClicked), for: .touchUpInside)
                cell!.workSpaceHowToView.pdfImageButton.addTarget(self, action: #selector(pdfButtonClicked), for: .touchUpInside)
                collectionViewCell = cell!
            }
        } else if collectionView == self.segmentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.tabCellsIdentifier, for: indexPath) as? TabCell
            if indexPath.row < self.objHowToViewModel.tabTitles.count && indexPath.row >= 0 {
                cell!.setupCell(text: self.objHowToViewModel.tabTitles[indexPath.item])
                collectionViewCell = cell!
            }
        }
        return collectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.segmentCollectionView {
            self.objHowToViewModel.selectedIndex = indexPath.item
            self.currentIndex = 0
            self.refreshContent(index: indexPath.row)
            self.objHowToViewModel.howToIndexPath = indexPath
            self.objHowToViewModel.setUpcollectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.objHowToViewModel.setUpcollectionView {
            return CGSize(width: self.baseView.frame.width, height: self.baseView.frame.height)
        } else {
            let cellsAcross: CGFloat = CGFloat(self.objHowToViewModel.tabTitles.count)
            let spaceBetweenCells: CGFloat = 0
            let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
            return CGSize(width: dim, height: 42)
        }
    }
}

//
//  GetStartedCollectionViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension GetStartedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = self.onboardCollectionView.frame.size.width * 0.4
        let itemHeight = self.onboardCollectionView.frame.size.height - 20
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objGetStartedViewModel.getArrayForOnboardingScreen().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if let cell = self.onboardCollectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.onboardCellIdentifier, for: indexPath) as? OnboardCollectionViewCell {
            if indexPath.row < self.objGetStartedViewModel.getArrayForOnboardingScreen().count && indexPath.row >= 0 {
                let inst = self.objGetStartedViewModel.getArrayForOnboardingScreen()[indexPath.row]
                cell.tileTitle.text = "\(inst.tileTitle)\t\t\t"
                cell.tileDescription.text = inst.tileDescription.replacingOccurrences(of: "<br", with: "\n")
                let imageURL = URL(string: "\(inst.tileImage)")
                cell.tileImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
                    cell.tileImage.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
                }
                cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                cell.layer.shadowRadius = 2.0
                cell.layer.shadowOpacity = 10.0
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.contentView.layer.masksToBounds = true
                collectionViewCell = cell
            }
        }
        return collectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.objGetStartedViewModel.getArrayForOnboardingScreen().count && indexPath.row >= 0 {
            let inst = self.objGetStartedViewModel.getArrayForOnboardingScreen()
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
                self.goToBeamSetUpViewController(fetchType: inst[indexPath.row].tileTitle)
            } else if indexPath.row == 3 {
                self.pushToNext(storyBoard: .howTo, identifier: Constants.HowToViewControllerIdentifier, titleStr: inst[indexPath.row].tileTitle)
            } else if indexPath.row == 4 {
                self.goToFaqGlossary()
            }
        }
    }
}

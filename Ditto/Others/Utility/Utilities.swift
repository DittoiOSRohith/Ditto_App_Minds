//
//  Utilities.swift
//
//  Created by Infosys on 03/10/19.
//  Copyright © 2019 Infosys. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

func fetchImageName(from urlString: String) -> String? {
    if let url = URL(string: urlString) {
        let withoutExt = url.deletingPathExtension()
        let name = withoutExt.lastPathComponent
        if name.hasSuffix("@3x") {
            return "\(name).png"
        } else {
            return "\(name)@3x.png"
        }
    }
    return FormatsString.emptyString
}
func getImageFromDirectory(imageUrl: String, patternDesignId: String, isTrail: Bool) -> UIImage? {
    let documentsURL = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    // set the name of the new folder
    var folderURL = documentsURL.appendingPathComponent("Patterns").appendingPathComponent("\(patternDesignId)")
    if isTrail {
        folderURL = documentsURL.appendingPathComponent("Trails").appendingPathComponent("\(patternDesignId)")
    } else {
        folderURL = documentsURL.appendingPathComponent("Patterns").appendingPathComponent("\(patternDesignId)")
    }
    do {
        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        let imageURL = URL(fileURLWithPath: "\(folderURL)").appendingPathComponent(getImageName(from: imageUrl)!)
        let image = UIImage(contentsOfFile: imageURL.path)
        if image == nil {
            return UIImage()
        }
        return image!
    } catch _ as NSError {
    }
    return nil
}
func getImageName(from urlString: String) -> String? {
    if let url = URL(string: urlString) {
        let withoutExt = url.deletingPathExtension()
        let name = withoutExt.lastPathComponent
        if name.hasSuffix("@3x") {
            return "\(name).png"
        } else {
            return "\(name)@3x.png"
        }
    }
    return FormatsString.emptyString
}
func presentCameraSettings(viewController: UIViewController) {
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: "\("Ditto Patterns") Would Like to Access the Camera", message: AlertMessage.cameraAccessDeniedText, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = .dark
        alertController.addAction(UIAlertAction(title: AlertTitle.cancel, style: .default) { _ in
            viewController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: AlertTitle.Settings, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                })
            }
        })
        if viewController.presentedViewController == nil {
            viewController.present(alertController, animated: true)
        }
    }
}

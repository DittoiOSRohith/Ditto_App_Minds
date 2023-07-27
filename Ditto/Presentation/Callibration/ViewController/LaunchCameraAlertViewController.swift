//
//  LaunchCameraAlertViewController.swift
//  Ditto
//
//  Created by Shefrin Hakeem on 12/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import FastSocket

class LaunchCameraAlertViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var calibrationAlertView: CalibartionAlertView!
    //MARK: VARIABLE DECLARATION
    var cameraLaunchPopupDelegate: LauchCameraPopUpDissmissDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calibrationAlertView.cancelButton.addTarget(self, action: #selector(self.calibrationCancel(_:)), for: .touchUpInside)
        self.calibrationAlertView.lauchCameraButton.addTarget(self, action: #selector(self.launchCamera(_:)), for: .touchUpInside)
    }
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.dismissLottie()
        }
    }
    @objc func launchCamera(_ sender: UIButton) {   // launch camera function tap on popup
        DispatchQueue.main.async {
            self.showLottie()
            self.dismiss(animated: true) {
                self.cameraLaunchPopupDelegate?.lauchCameraPopUpScreenDissmiss()
            }
        }
    }
    @objc func calibrationCancel(_ sender: UIButton) {  // Tap calibration launch cancel action and Send black image
        let image = UIImage(named: ImageNames.wsLaunchImage)
        self.calibrationAlertView.isHidden = true
        DispatchQueue.main.async {
            self.dismiss(animated: false) {
                DispatchQueue.global(qos: .background).async {
                    Thread.sleep(forTimeInterval: 1)
                    self.sendImage(img: image!)
                }
            }
        }
    }
    func sendImage (img: UIImage) {   // send image to projector
        do {
            guard let client = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)), client.connect() else { return }
            if let data =  img.pngData() {
                data.withUnsafeBytes { dataBytes in
                    if let buffer: UnsafePointer<CChar> = dataBytes.baseAddress?.assumingMemoryBound(to: CChar.self) {
                        _ = client.sendBytes(buffer, count: data.count)
                    }
                }
            }
        }
    }
}

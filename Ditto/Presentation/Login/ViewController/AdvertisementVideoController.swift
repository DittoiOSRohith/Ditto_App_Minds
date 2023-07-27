//
//  AdvertisementVideoController.swift
//  Ditto
//
//  Created by Neb Shaw on 5/8/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import YouTubeiOSPlayerHelper

class AdvertisementVideoController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var skipVideo: UIButton!
    @IBOutlet weak var watchVideoButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var avoidWhiteFlashImgVu: UIImageView!
    @IBOutlet weak var youtubeVdoView: YTPlayerView!
    //MARK: VARIABLE DECLARATION
    var isFromSceen = FormatsString.emptyString
    var videoUrl = FormatsString.emptyString
    var videoTitle = FormatsString.dittoAppOverview
    let avPlayerController = AVPlayerViewController()
    var closeThumbnail: (() -> Void)?
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.isPad {
            self.skipVideo.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -190)
        }
        if self.isFromSceen == FromScreen.getStarted {
            self.videoTitle = FormatsString.dittoTour
        } else if self.isFromSceen == FromScreen.FAQScreen {
            self.videoTitle = FormatsString.glossary
        }
        self.skipVideo.addTarget(self, action: #selector(self.skipButtonDidPress), for: .touchUpInside)
        self.titleLabel.text = "\(self.videoTitle)"
        self.view.bringSubviewToFront(self.titleLabel)
        self.view.bringSubviewToFront(self.skipVideo)
        self.view.bringSubviewToFront(self.watchVideoButton)
        self.view.bringSubviewToFront(self.closeButton)
        if self.isFromSceen == FromScreen.tutorial || self.isFromSceen == FromScreen.getStarted || self.isFromSceen == FromScreen.FAQScreen || self.isFromSceen == FromScreen.FAQVideoScreen || self.isFromSceen == FromScreen.workspace {
            self.skipVideo.isHidden = true
            self.closeButton.isHidden = false
        } else {
            self.skipVideo.isHidden = false
            self.closeButton.isHidden = true
        }
        self.setUpCustomView()
        self.youtubeVdoView.backgroundColor = UIColor.black
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 0, "showinfo": 0, "autoplay": 1, "modestbranding": 1, "rel": 0]
            self.youtubeVdoView.load(withVideoId: self.getID(screenType: "\(self.isFromSceen)"), playerVars: playvarsDic)
            self.youtubeVdoView.delegate = self
            self.watchVideoButton.isHidden = true
        } else {
            self.noNetworkConnectionAlert()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.youtubeVdoView.playVideo()
        if let manager = NetworkReachabilityManager(), !manager.isReachable {
            self.noNetworkConnectionAlert()
        }
        self.avPlayerController.player?.addObserver(self, forKeyPath: FormatsString.rate, options: [], context: nil)   // TO OBSERVE STATUS OF VIDEO...timeControlStatus CAN ALSO BE USED
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === self.avPlayerController.player {
            if keyPath == FormatsString.rate {
                self.watchVideoButton.isHidden = self.avPlayerController.player!.rate > 0 ? true : false
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.avPlayerController.player?.removeObserver(self, forKeyPath: FormatsString.rate)
    }
    func setUpCustomView() {   // Setup a custom View for VideoPalyer
        self.view.backgroundColor = .black
        self.view.isHidden = false
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .zero
    }
    func initializeVideoView() -> AVPlayerViewController {   // Initialising AVPlayerVC
        let player = AVPlayer(url: self.getURL(screenType: self.isFromSceen))
        self.avPlayerController.player = player
        self.avPlayerController.view.frame = self.view.bounds
        self.avPlayerController.view.frame.origin.y = self.view.bounds.origin.y
        self.avPlayerController.view.frame.size.height = self.view.bounds.size.height
        self.avPlayerController.view.frame.origin.x = self.view.bounds.origin.x
        self.avPlayerController.view.frame.size.width = self.view.bounds.size.width
        self.avPlayerController.modalPresentationStyle = .fullScreen
        self.avPlayerController.showsPlaybackControls = true
        return self.avPlayerController
    }
    func getURL(screenType: String) -> URL {   // Get Youtube URL
        if var url = URL(string: "\(self.videoUrl)") {
            if self.videoUrl != FormatsString.emptyString {
                if let url1 = URL(string: getYoutubeId(youtubeUrl: "\(self.videoUrl)")!), url.absoluteString.isEmpty {
                    url = url1
                    return url
                }
            } else {
                if let url1 = URL(string: getYoutubeId(youtubeUrl: "\(CommonConst.demoVideoURLText)")!), url.absoluteString.isEmpty {
                    url = url1
                    return url
                }
            }
        }
        return URL(string: "\(Apis.seeMore)")!
    }
    func getID(screenType: String) -> String {   // Get youtube ID based on screen type
        if self.videoUrl != FormatsString.emptyString {
            return "\(self.videoUrl)".youtubeID!
        } else {
            return FormatsString.defaultYoutubeID
        }
    }
    //MARK: UI COMPONENT ACTIONS
    @objc func skipButtonDidPress() {  // Skip button action
        CommonConst.navCheckValue = 1
        self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
    }
    @IBAction func watchVideoButtonClicked(_ sender: UIButton) {  // watch icon action
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            self.avPlayerController.player?.play()
            self.watchVideoButton.isHidden = true
        } else {
            self.noNetworkConnectionAlert()
        }
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {   // close icon action
        self.closeThumbnail?()
        self.dismiss(animated: true, completion: nil)
    }
}

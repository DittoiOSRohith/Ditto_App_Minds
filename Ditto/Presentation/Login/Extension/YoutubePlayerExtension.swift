//
//  YoutubePlayerExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import YouTubeiOSPlayerHelper

extension AdvertisementVideoController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
        self.avoidWhiteFlashImgVu.backgroundColor = UIColor.clear
    }
}

//
//  WZLPlayerControlsView.swift
//  WZLVideoPlayer
//
//  Created by Sylvain Bouchard on 2018-08-09.
//  Copyright © 2018 Waizu Labs Inc. All rights reserved.

import Foundation
import AVFoundation
import UIKit
import ASBPlayerScrubbing

public class WZUPlayerControlsView: UIView {

    @IBOutlet public var playerScrubbing: ASBPlayerScrubbing!
    @IBOutlet var slider: UISlider!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!

    private let playerKeyPath = "player"
    private let rateKeyPath = "rate"
    
    deinit {
        self.playerScrubbing.removeObserver(self, forKeyPath: playerKeyPath)
        self.playerScrubbing.player.removeObserver(self, forKeyPath: rateKeyPath)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.playerScrubbing.addObserver(self, forKeyPath: playerKeyPath, options: .new, context: nil)
        let bundle = Bundle(for: WZUPlayerControlsView.self)
        self.slider.setThumbImage(UIImage(named: "oval", in: bundle, compatibleWith: nil), for: .normal)
        self.layer.cornerRadius = 8.0
    }

    @IBAction func toggleTimeLabel(_ sender: AnyObject) {
        self.remainingTimeLabel.isHidden = !self.remainingTimeLabel.isHidden
        self.durationLabel.isHidden = !self.remainingTimeLabel.isHidden
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                    change: [NSKeyValueChangeKey: Any]?,
                                    context: UnsafeMutableRawPointer?) {
        
        if keyPath == playerKeyPath {
            if playerScrubbing.player != nil {
                playerScrubbing.player.addObserver(self, forKeyPath: rateKeyPath, options: .new, context: nil)
            }
        } else {
            if let player = object as? AVPlayer {
                playPauseButton.isSelected = (player.rate != 0)
            }
        }
    }
}

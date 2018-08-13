//
//  WZLVideoPlayerController.swift
//  WZLVideoPlayer
//
//  Created by Sylvain Bouchard on 2018-08-09.
//  Copyright © 2018 Waizu Labs Inc. All rights reserved.

import UIKit
import AVKit

public class WZUVideoPlayerController: UIViewController {

    @IBOutlet weak var playerView: ZoomablePlayerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var accessoryViewTimer: Timer?
    @IBOutlet weak var controlBarView : WZUPlayerControlsView!
    
    var player = AVPlayer()
    
    var isPlaying = false
    
    public var videoURL = URL(string: "")

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        if let url = videoURL {
            // AVPlayer view
            player = AVPlayer(url: url)
            addVideoPlayer()
            
            // Initial full screen play button
            playButton.layer.cornerRadius = 0.5 * playButton.bounds.size.width
            playButton.clipsToBounds = true
            
            // Player controls is hidden by default
            self.controlBarView.playerScrubbing.player = player
            self.controlBarView.alpha = 0
            self.closeButton.alpha = 0
            self.closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.50)
            
            // Gesture
            // Single tap: Togge the player's control view
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            playerView.addGestureRecognizer(tap)
            
            // Double tap: reset the zoom scale
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTap.numberOfTapsRequired = 2
            playerView.addGestureRecognizer(doubleTap)
            
            // Scrollview config for zooming
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 5.0
            scrollView.pinchGestureRecognizer?.isEnabled = true
            scrollView.bounces = false
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.playView.isHidden = true
            self.togglePlayPause()
        })
    }
    
    @IBAction func dismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Toggle the player controls view
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isPlaying {
            displayControlsView(!controlsViewVisible())
        }
    }
    
    func displayControlsView(_ visible: Bool) {
        if visible == controlsViewVisible() {
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction], animations: { [unowned self] in
                self.controlBarView.alpha = (visible ? 1.0 : 0.0)
                self.closeButton.alpha = (visible ? 1.0 : 0.0)
        }, completion: nil)
    }
    
    func controlsViewVisible() -> Bool {
        return (self.controlBarView.alpha == 1.0)
    }
    
    private func togglePlayPause(){
        if isPlaying {
            isPlaying = false
            player.pause()
        }
        else {
            isPlaying = true
            player.play()
        }
    }
    
    // Double tap reset zoom
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        self.scrollView.zoomScale = 1.0
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func addVideoPlayer() {
        let castedLayer = playerView.layer as! AVPlayerLayer
        castedLayer.player = player
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override open var prefersStatusBarHidden: Bool {
        return true
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerView.frame = self.view.frame
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.scrollView.zoomScale = 1.0
            self.playerView.layer.layoutIfNeeded()
            UIView.animate(
                withDuration: context.transitionDuration,
                animations: {
                    self.playerView.layer.frame = self.playerView.bounds
            })
        }, completion: nil)
    }
}

class ZoomablePlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

extension WZUVideoPlayerController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.playerView
    }
}

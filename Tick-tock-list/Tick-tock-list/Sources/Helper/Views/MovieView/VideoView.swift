//
//  MovieView.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/28/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVKit

protocol VideoViewProtocol {

    func setupMovieView(withPlayerLayer playerLayer: AVPlayerLayer)
    func setupPlayLayer()
}

class VideoView: UIView, VideoViewProtocol {

    private var playerLayer: AVPlayerLayer?

    func setupMovieView(withPlayerLayer playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        self.layer.insertSublayer(playerLayer, at: 0)
    }

    func setupPlayLayer() {
        playerLayer?.removeFromSuperlayer()
        guard let playerLayer = self.playerLayer else {
            return
        }
        setupPlayerLayer(playerLayer)
        layer.insertSublayer(playerLayer, at: 0)
    }

    private func setupPlayerLayer(_ playerLayer: AVPlayerLayer) {
        playerLayer.frame = bounds
        playerLayer.bounds = bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
    }
}

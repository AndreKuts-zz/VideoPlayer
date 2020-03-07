//
//  MovieView.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/28/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVKit

protocol VideoViewProtocol {
    var player: AVPlayer? { get set }
}

class VideoView: UIView, VideoViewProtocol {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }

        set {
            playerLayer.player = newValue
        }
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
}

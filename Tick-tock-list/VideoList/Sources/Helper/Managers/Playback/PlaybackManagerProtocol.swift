//
//  PlaybackManagerProtocol.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation

protocol PlaybackManagerProtocol: class {

    var delegate: PlaybackManagerDelegate? { get set }
    var player: AVPlayer { get }

    func setAsset(_ asset: AVAsset?)
    func setPlayerItem(_ playerItem: AVPlayerItem?)

    func playVideo()
    func pause()
    func onPlayButtonPressed(isPlay: Bool)
}

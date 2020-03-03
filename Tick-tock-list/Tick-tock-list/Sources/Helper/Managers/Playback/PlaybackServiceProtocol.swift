//
//  PlaybackServiceProtocol.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation

protocol PlaybackServiceProtocol {

    var delegate: PlaybackManagerDelegate? { get set }
    var player: AVPlayer { get }
    var queuePlayer: AVQueuePlayer { get }

    func set(_ asset: AVAsset?)
    func onPlayButtonPressed()
    func playVideo(startPlaying: Bool)
}

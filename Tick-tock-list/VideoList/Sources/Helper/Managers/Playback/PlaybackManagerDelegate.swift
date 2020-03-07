//
//  PlaybackManagerDelegate.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation

protocol PlaybackManagerDelegate: AnyObject {
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playFinished: Bool)
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playerError error: Error?)
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playerStartPlay player: AVPlayer)
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playerReadyToPlay player: AVPlayer)
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, preferredBitrate: Double, currentBitrate: Double)
}

extension PlaybackManagerDelegate {
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playFinished: Bool) { }
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playerError error: Error?) { }
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playerStartPlay player: AVPlayer) { }
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, playerReadyToPlay player: AVPlayer) { }
    func playbackManager(_ playbackManager: PlaybackManagerProtocol, preferredBitrate: Double, currentBitrate: Double) { }
}

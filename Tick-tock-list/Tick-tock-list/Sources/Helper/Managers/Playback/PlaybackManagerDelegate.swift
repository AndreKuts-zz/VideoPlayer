//
//  PlaybackManagerDelegate.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation

protocol PlaybackManagerDelegate: AnyObject {

    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playFinished: Bool)
    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerError error: Error?)
    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerStartPlay player: AVPlayer)
    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerReadyToPlay player: AVPlayer)
    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerStartPlyaing player: AVPlayer)
    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, preferredBitrate: Double, currentBitrate: Double)
}

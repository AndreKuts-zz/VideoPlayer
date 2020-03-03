//
//  PlaybackService.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation

private enum Constant {
    static let defaultCurrentPreferredPeakBitRate: Double = 1000000.0
    static let periodicPlayerObesrvervingTimeInterval: CMTime = CMTimeMake(value: 1, timescale: 1)
    static let assetKeys = ["playable", "hasProtectedContent"]
}

class PlaybackService {

    weak var delegate: PlaybackManagerDelegate?

    private let _queuePlayer = AVQueuePlayer()

    private let singlPlayer: AVPlayer

    private var currentPreferredPeakBitRate = Constant.defaultCurrentPreferredPeakBitRate
    private var readyForPlayback = false
    private var isVideoPlayingFinished = false
    private var isVideoPlaying = false
    private var playerItemObserver: NSKeyValueObservation?
    private var urlAssetObserver: NSKeyValueObservation?
    private var playerObserver: NSKeyValueObservation?

    private var playerItem: AVPlayerItem? {
        willSet {
            playerItemObserver?.invalidate()
        }

        didSet {
            playerItemObserver = playerItem?.observe(\AVPlayerItem.status,
                                                     options: [.new, .initial]) { [weak self] (item, _) in
                guard let self = self else {
                    return
                }
                if item.status == .readyToPlay {
                    if !self.readyForPlayback {
                        self.readyForPlayback = true
                        self.delegate?.streamPlaybackService(self, playerReadyToPlay: self.player)
                    }
                } else if item.status == .failed {
                    let error = item.error
                    self.delegate?.streamPlaybackService(self, playerError: error)
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private var asset: AVAsset? {
        willSet {
            urlAssetObserver?.invalidate()
        }

        didSet {
            readyForPlayback = false
            if let asset = asset {
                urlAssetObserver = asset.observe(\AVURLAsset.isPlayable,
                                                 options: [.new, .initial]) { [weak self] urlAsset, _ in
                    guard let self = self, urlAsset.isPlayable == true else {
                        return
                    }
                    self.playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: Constant.assetKeys)
                    self.playerItem?.preferredPeakBitRate = self.currentPreferredPeakBitRate
                    self.singlPlayer.replaceCurrentItem(with: self.playerItem)
                    self.singlPlayer.addPeriodicTimeObserver(forInterval: Constant.periodicPlayerObesrvervingTimeInterval,
                                                        queue: .main,
                                                        using: { [weak self] _ -> Void in
                                                            self?.checkCurrentBitRate()
                    })
                }
            } else {
                playerItem = nil
                player.replaceCurrentItem(with: nil)
            }
        }
    }

    // MARK: Intitialization

    init(delegate: PlaybackManagerDelegate? = nil) {
        self.delegate = delegate
        singlPlayer = AVPlayer()
        playerObserver = player.observe(\AVPlayer.currentItem, options: [.new]) { [weak self] _, _ in
            guard let self = self else {
                return
            }
            self.checkCurrentBitRate()
        }
        player.usesExternalPlaybackWhileExternalScreenIsActive = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
        playerItemObserver?.invalidate()
        urlAssetObserver?.invalidate()
        playerObserver?.invalidate()
    }

    private func checkCurrentBitRate() {
        guard let lastEvent = singlPlayer.currentItem?.accessLog()?.events.last else {
            return
        }
        print("lastEvent.observedBitrate    = \(lastEvent.observedBitrate)")
        self.delegate?.streamPlaybackService(self,
                                             preferredBitrate: currentPreferredPeakBitRate,
                                             currentBitrate: lastEvent.observedBitrate)
        if currentPreferredPeakBitRate < lastEvent.observedBitrate {
            currentPreferredPeakBitRate = lastEvent.observedBitrate
        }
    }

    private func setupFinishPlayingHandler() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerFinished), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @objc private func playerFinished(isFinished: Bool) {
        guard !isVideoPlayingFinished else {
            return
        }
        isVideoPlayingFinished = true
        delegate?.streamPlaybackService(self, playFinished: isVideoPlayingFinished)
    }
}

extension PlaybackService: PlaybackServiceProtocol {

    var player: AVPlayer {
        return singlPlayer
    }

    var queuePlayer: AVQueuePlayer {
        return _queuePlayer
    }

    func onPlayButtonPressed() {
        if isVideoPlaying {
            player.pause()
        } else {
            player.play()
        }
        isVideoPlaying.toggle()
    }

    func set(_ asset: AVAsset?) {
        self.asset = asset
    }

    func playVideo(startPlaying: Bool) {
        guard startPlaying else {
            return
        }
        isVideoPlaying = true
        delegate?.streamPlaybackService(self, playerStartPlay: player)
        setupFinishPlayingHandler()
        isVideoPlayingFinished = false
        player.play()
    }
}


//
//  PlaybackManager.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation

class PlaybackManager {

    weak var delegate: PlaybackManagerDelegate?

    let player: AVPlayer

    private var currentPreferredPeakBitRate = Constants.defaultCurrentPreferredPeakBitRate
    private var readyForPlayback = false
    private var isVideoPlayingFinished = false
    private var isVideoPlaying = false

    private var urlAssetObserver: NSKeyValueObservation?
    private var playerObserver: NSKeyValueObservation?

    private var asset: AVAsset? {

        willSet {
            urlAssetObserver?.invalidate()
        }

        didSet {
            readyForPlayback = false
            if let asset = asset {
                urlAssetObserver = asset.observe(\AVURLAsset.isPlayable, options: [.new, .initial]) { [weak self] urlAsset, _ in
                    guard let self = self, urlAsset.isPlayable else {
                        return
                    }
                    asset.loadValuesAsynchronously(forKeys: Constants.assetKeys) {
                        self.playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: Constants.assetKeys)
                        self.playerItem?.preferredPeakBitRate = self.currentPreferredPeakBitRate
                        self.player.replaceCurrentItem(with: self.playerItem)
                        self.player.addPeriodicTimeObserver(forInterval: Constants.periodicPlayerObesrvervingTimeInterval,
                                                            queue: .main,
                                                            using: { [weak self] _ -> Void in
                                                                self?.checkCurrentBitRate()
                        })
                    }
                }
            } else {
                playerItem = nil
                player.replaceCurrentItem(with: nil)
            }
        }
    }

    private var playerItem: AVPlayerItem? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.player.replaceCurrentItem(with: self.playerItem)
                self.playerItem?.preferredPeakBitRate = self.currentPreferredPeakBitRate
                self.delegate?.playbackManager(self, playerReadyToPlay: self.player)
            }
        }
    }

    // MARK: Intitialization

    init(delegate: PlaybackManagerDelegate? = nil) {
        self.delegate = delegate
        self.player = AVPlayer()
        self.player.usesExternalPlaybackWhileExternalScreenIsActive = true
        self.player.addPeriodicTimeObserver(forInterval: Constants.periodicPlayerObesrvervingTimeInterval,
                                            queue: .global(qos: .background),
                                            using: { [weak self] _ -> Void in
                                                self?.checkCurrentBitRate()
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        urlAssetObserver?.invalidate()
        playerObserver?.invalidate()
    }
}

// MARK: - PlaybackManagerProtocol

extension PlaybackManager: PlaybackManagerProtocol {

    func setPlayerItem(_ playerItem: AVPlayerItem?) {
        self.playerItem = playerItem
    }

    func setAsset(_ asset: AVAsset?) {
        self.asset = asset
    }

    func playVideo() {
        delegate?.playbackManager(self, playerStartPlay: player)
        setupFinishPlayingHandler()
        isVideoPlayingFinished = false
        play()
    }

    func onPlayButtonPressed(isPlay: Bool) {
        if isPlay {
            play()
        } else {
            pause()
        }
    }

    func pause() {
        isVideoPlaying = false
        player.pause()
    }
}

private extension PlaybackManager {

    func play() {
        isVideoPlaying = true
        player.play()
    }

    func setupFinishPlayingHandler() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerFinished), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @objc func playerFinished(isFinished: Bool) {
        guard !isVideoPlayingFinished else {
            return
        }
        isVideoPlayingFinished = true
        delegate?.playbackManager(self, playFinished: isVideoPlayingFinished)
    }

    func checkCurrentBitRate() {

        guard let lastEvent = player.currentItem?.accessLog()?.events.last else {
            return
        }

        print("currentPreferredPeakBitRate  = \(currentPreferredPeakBitRate)")
        print("lastEvent.observedBitrate    = \(lastEvent.observedBitrate)")
        print("lastEvent.switchBitrate      = \(lastEvent.switchBitrate)")
        print("lastEvent.observedMaxBitrate = \(lastEvent.observedMaxBitrate)")

        self.delegate?.playbackManager(self,
                                       preferredBitrate: currentPreferredPeakBitRate,
                                       currentBitrate: lastEvent.observedBitrate)
        if currentPreferredPeakBitRate < lastEvent.observedBitrate {
            currentPreferredPeakBitRate = lastEvent.observedBitrate
        }
    }
}

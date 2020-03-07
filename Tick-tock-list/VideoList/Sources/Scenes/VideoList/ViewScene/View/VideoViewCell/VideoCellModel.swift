//
//  VideoCellModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation.NSURL
import AVFoundation.AVPlayerItem
import RxSwift
import RxCocoa

class VideoCellModel {

    let videoPlyaer: BehaviorRelay<AVPlayer?>
    let playbackManager: PlaybackManagerProtocol
    let loadedPlayerItem: BehaviorRelay<AVPlayerItem?>
    let state: BehaviorRelay<VideoModelState>

    private let user: UserModel
    private let videoQuality: VideoQuality
    private let videoLoader: VideoPreloader
    private let disposeBag: DisposeBag

    init(userModel: UserModel, playbackManager: PlaybackManager, videoLoader: VideoPreloader) {

        self.user = userModel
        self.playbackManager = playbackManager
        self.videoLoader = videoLoader

        self.state = .init(value: .notReady)
        self.loadedPlayerItem = .init(value: nil)
        self.videoPlyaer = .init(value: nil)
        self.videoQuality = .low
        self.disposeBag = DisposeBag()

        configure()
    }
}

// MARK: - VideoCellModelProtocol

extension VideoCellModel: VideoCellModelProtocol {

    var title: String { return user.name }
    var info: String { return "\(user.age)" }
    var id: String { return user.id }
    var previewImageURL: URL? { return user.previewPhotoURL }

    func playVideo() {
        playbackManager.playVideo()
    }

    func stopVideo() {
        state.accept(.pause)
        playbackManager.pause()
    }
}

// TODO: Refactoring using Rx, remove delegate
// MARK: - PlaybackManagerDelegate

extension VideoCellModel: PlaybackManagerDelegate {

    func playbackManager(_ streamPlaybackService: PlaybackManagerProtocol, playerReadyToPlay player: AVPlayer) {
        videoPlyaer.accept(player)
        state.accept(.ready)
    }

    func playbackManager(_ streamPlaybackService: PlaybackManagerProtocol, playerStartPlay player: AVPlayer) {
        state.accept(.plaing)
    }

    func playbackManager(_ streamPlaybackService: PlaybackManagerProtocol, playFinished: Bool) {
        state.accept(.finished)
    }

    func playbackManager(_ streamPlaybackService: PlaybackManagerProtocol, playerError error: Error?) {
        state.accept(.failed)
    }
}

private extension VideoCellModel {

    var videoUrl: URL? {
        switch videoQuality {
        case .high: return URL(string: user.cards.first { $0.video != nil }?.video?.files.hls ?? "")
        case .low: return URL(string: user.cards.first { $0.video != nil }?.video?.files.hls ?? "")
        }
    }

    func configure() {
        playbackManager.delegate = self
        configureRx()
        preloadVideo()
    }

    func configureRx() {
        loadedPlayerItem
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: { [weak self] item in
                self?.state.accept(.ready)
                self?.playbackManager.setPlayerItem(item)
            })
            .disposed(by: disposeBag)
    }

    func preloadVideo() {
        switch state.value {
        case .notReady, .failed, .finished:
            loadVideo(videoURL: videoUrl)
        case .plaing, .ready:
            break // Wait for user actions
        case .loading:
            break // TODO: show loader
        case .pause:
            break // TODO: show pause button
        }
    }

    func loadVideo(videoURL: URL?) {
        if let url = videoUrl {
            state.accept(.loading)
            videoLoader.loadUrl(videoURL: url)
                .asObservable()
                .bind(to: loadedPlayerItem)
                .disposed(by: disposeBag)
        } else {
            state.accept(.failed)
        }
    }
}

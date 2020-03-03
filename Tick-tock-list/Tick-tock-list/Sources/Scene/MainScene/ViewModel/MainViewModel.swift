//
//  MainViewModel.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation
import RxSwift
import RxDataSources

class MainSceneViewModel {

    private let disposeBag: DisposeBag
    private var model: MainVMModel

    var playerManager: PlaybackServiceProtocol
    var sections: PublishSubject<[SectionModel<VideoCellModel>]>
    var isDataRedy: BehaviorSubject<Bool>

    init(model: MainVMModel = MainVMModel(), disposeBag: DisposeBag = DisposeBag(), playerManager: PlaybackServiceProtocol = PlaybackService()) {
        self.model = model
        self.disposeBag = disposeBag
        self.sections = PublishSubject<[SectionModel]>()
        self.isDataRedy = BehaviorSubject<Bool>(value: false)
        self.playerManager = playerManager

        self.playerManager.delegate = self
        configureRx()
    }

    func loadData() {
        isDataRedy.onNext(false)
        model.loadData()
    }

    func showNextItem() {
        model.loadNextItem()
    }

    private func configureRx() {
        model.userListDriver
            .map { [weak self] userList -> SectionModel<VideoCellModel> in
                var items: [VideoCellModel] = []
                userList.users.forEach({ userModel in
                    items.append(VideoCellModel(userModel: userModel, videoQuality: self?.model.videoQuality.value ?? .high))
                })
                return SectionModel(items: items)
            }
            .drive(onNext: { [weak self] sectionModel in
                self?.isDataRedy.onNext(true)
                self?.sections.onNext([sectionModel])
            })
            .disposed(by: disposeBag)
    }
}

// MARK: PlaybackManagerDelegate

extension MainSceneViewModel: PlaybackManagerDelegate {

    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playFinished: Bool) { }
    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerError error: Error?) { }

    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerStartPlay player: AVPlayer) {
    }

    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerReadyToPlay player: AVPlayer) {
        playerManager.playVideo(startPlaying: true)
    }

    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, playerStartPlyaing player: AVPlayer) { }
    func streamPlaybackService(_ streamPlaybackService: PlaybackServiceProtocol, preferredBitrate: Double, currentBitrate: Double) { }
}

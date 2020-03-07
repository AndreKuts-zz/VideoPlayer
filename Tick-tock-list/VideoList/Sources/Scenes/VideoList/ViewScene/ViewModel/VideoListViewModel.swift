//
//  VideoListViewModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa
import RxDataSources

class VideoListViewModel {

    private let disposeBag: DisposeBag
    private let model: VideoListModel
    private let sections: BehaviorRelay<[SectionModel<VideoCellModel>]>

    init(model: VideoListModel) {

        self.model = model
        self.sections = .init(value: [])
        self.disposeBag = DisposeBag()

        configureRx()
    }
}

extension VideoListViewModel: VideoListViewModelProtocol {

    var sectionsDriver: Driver<[SectionModel<VideoCellModel>]> {
        return sections.asDriver(onErrorJustReturn: [])
    }

    func loadData() {
        model.loadUserList()
    }

    func playVideo(at indexPath: IndexPath) {

        sections.value
            .map { $0.items.first { $0.state.value == .plaing } }
            .filter { $0 != nil }.map { $0! }
            .forEach { elsement in
                elsement.stopVideo()
        }

        let section = sections.value.enumerated().first(where: { $0.offset == indexPath.section })?.element
        let element = section?.items.enumerated().first(where: { $0.offset == indexPath.row })?.element
        element?.playVideo()
    }
}

private extension VideoListViewModel {

    private func configureRx() {
        model.userList
            .skip(1)
            .map { $0.users[0...4].compactMap { userModel in VideoCellModel(userModel: userModel, playbackManager: PlaybackManager(), videoLoader: VideoPreloader())}}
            .map { [SectionModel(items: $0)] }
            .bind(to: sections)
            .disposed(by: disposeBag)
    }
}

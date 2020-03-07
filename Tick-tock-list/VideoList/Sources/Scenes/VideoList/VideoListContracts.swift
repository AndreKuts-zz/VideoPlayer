//
//  VideoListContracts.swift
//  VideoList
//
//  Created by Kuts, Andrey on 3/5/20.
//  Copyright © 2020 Kuts, Andrey. All rights reserved.
//

import RxCocoa
import AVKit

// MARK: - Views

protocol VideoViewCellProtocol: AnyObject {
    func setupUI()
    func configure(withModel model: VideoCellModelProtocol)
}

// MARK: - ViewModels

protocol VideoListViewModelProtocol: AnyObject {

    associatedtype CellType

    var sectionsDriver: Driver<[SectionModel<CellType>]> { get }

    func loadData()
    func playVideo(at indexPath: IndexPath)
}

// MARK: - Models

protocol VideoCellModelProtocol: AnyObject {

    var state: BehaviorRelay<VideoModelState> { get }
    var id: String { get }
    var title: String { get }
    var info: String { get }
    var previewImageURL: URL? { get }
    var videoPlyaer: BehaviorRelay<AVPlayer?> { get }
    var playbackManager: PlaybackManagerProtocol { get }

    func playVideo()
    func stopVideo()
}

protocol VideoListNodeModelProtocol: AnyObject {
    var itemsCount: Int { get }
    var sectionsCount: Int { get }
    var sections: Driver<[SectionModel<VideoCellModel>]> { get }
}


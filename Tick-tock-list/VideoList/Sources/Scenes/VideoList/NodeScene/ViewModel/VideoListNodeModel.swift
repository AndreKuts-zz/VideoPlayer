//
//  VideoListNodeModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa
import RxDataSources

class VideoListNodeModel {

    private let disposeBag: DisposeBag
    private let model: VideoListModel

    private var loadedItemsCount = 0
    private var isAllItemsLoaded = false

    var totalItemCount = 0
    var sections: PublishSubject<[SectionModel<VideoCellModel>]>

    init(model: VideoListModel) {

        self.model = model
        self.disposeBag = DisposeBag()
        self.sections = .init()

        configureRx()
    }

    func loadData() {
        model.loadUserList()
    }

//    func loadUserList(_ count: Int = 10) {
//        var total = model.userListDriver.b
//        totalItemCount = model.userList.value.users.count
//        let itemAvalibel = totalItemCount - loadedItemsCount
//        let loadingCount = itemAvalibel > count ? count : itemAvalibel
//
//        guard !isAllItemsLoaded, loadingCount >= 0 else {
//            return
//        }
//
//        let items = Array(model.userList.value.users[loadedItemsCount..<loadedItemsCount + loadingCount])
//
//        paginationsItems.onNext(items.map { VideoCellModel(userModel: $0) })
//        loadedItemsCount += loadingCount
//        isAllItemsLoaded = totalItemCount - loadedItemsCount <= 0
//    }

    private func configureRx() {
//
//        model.userListDriver
//            .skip(1)
//            .map { SectionModel(items: $0.users[0...4].map { VideoCellModel(userModel: $0) })}
//            .drive(onNext: { [weak self] sectionModel in
//                self?.sections.onNext([sectionModel])
////                self?.loadUserList()
//            })
//            .disposed(by: disposeBag)
    }
}

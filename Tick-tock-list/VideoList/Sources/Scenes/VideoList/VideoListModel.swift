//
//  MainVMModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class VideoListModel {

    lazy var videoQualityManager = VideoSourceSelectorService()
    let videoQuality: BehaviorRelay<VideoQuality>
    let userList: BehaviorRelay<UserListModel>

    private let userApi: UserListNetworking

    init(userApi: UserListNetworking) {

        self.userApi = userApi
        self.videoQuality = .init(value: .high)
        self.userList = .init(value: UserListModel(users: []))

        checkSpeed()
    }

    func loadUserList() {
        userApi.getList { [weak self] result in
            switch result {
            case .success(let list):
                self?.userList.accept(list)
            case .failure:
                break // TODO: Handele error
            }
        }
    }
}

private extension VideoListModel {

    func checkSpeed() {
        videoQualityManager.makeRequestVideoQuality()
        videoQualityManager.onVideoQualityReceivedCallback = { [weak self] quality in
            self?.videoQuality.accept(quality)
        }
    }
}

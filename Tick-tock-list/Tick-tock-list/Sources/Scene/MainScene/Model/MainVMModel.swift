//
//  MainVMModel.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainVMModel {

    internal lazy var userListDriver = userList.asDriver(onErrorDriveWith: .never())
    internal lazy var videoQualityManager = VideoSourceSelectorService()
    internal lazy var videoQuality = BehaviorRelay<VideoQuality>(value: .high)

    private let userList: BehaviorSubject<UserListModel>
    private let userApi: MainUserNetworking
    private let test: Test

    // WARNING: TMP
    private let bundl = Bundle.main
    private let fileName = "json"

    init() {
        userList = BehaviorSubject<UserListModel>(value: UserListModel(users: []))
        userApi = ServiceLocator.inject()
        test = ServiceLocator.inject()
        let a = (test as? MainUserNetworking)
        sheckSpeed()
    }

    func loadData() {
        guard let path = bundl.path(forResource: fileName, ofType: "json"),
            let url = URL(fileURLWithPath: path) as? URL,                                       // TODO: refactoring this case
            let data = try? Data(contentsOf: url),
            let decodedList = try? Networking.decoder.decode(UserListModel.self, from: data) else {
                return
        }
        self.userList.onNext(decodedList)
        
        userApi.getList { result in
            switch result {
            case .success(let model): self.userList.onNext(model)
            case .failure(let error): break
            }
        }
    }

    func loadNextItem()  {
        
    }

    private func getUserListModel(callback: @escaping (UserListModel) -> Void) {
        guard let path = bundl.path(forResource: fileName, ofType: "json"),
            let url = URL(fileURLWithPath: path) as? URL,                                       // TODO: refactoring this case
            let data = try? Data(contentsOf: url),
            let decodedList = try? Networking.decoder.decode(UserListModel.self, from: data) else {
                return
        }
        callback(decodedList)
    }

    private func sheckSpeed() {
        videoQualityManager.makeRequestVideoQuality()
        videoQualityManager.onVideoQualityReceivedCallback = { [weak self] quality in
            self?.videoQuality.accept(quality)
        }
    }
}

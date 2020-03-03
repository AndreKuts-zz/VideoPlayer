//
//  VideoCellModel.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation.NSURL
import AVFoundation

protocol VideoCellModelProtocol {

//    var isVideoPlaing: Bool { get }
//    var title: String { get }
//    var info: String { get }
//    var playerItem: AVPlayerItem? { get }
}

class VideoCellModel: VideoCellModelProtocol {

    private let videoQuality: VideoQuality

    private var user: UserModel

    init(userModel: UserModel, videoQuality: VideoQuality) {
        self.videoQuality = videoQuality
        self.user = userModel
    }


    func getAssetUrl() -> URL? {

        return URL(string: user.cards.first { $0.video != nil }?.video?.files.hls ?? "")

//        switch videoQuality {
//        case .high:
//            return URL(string: user.cards.first { $0.video != nil }?.video?.files.hls ?? "")
//        case .low:
//            return URL(string: user.cards.first { $0.video != nil }?.video?.files.hls ?? "")
//        }
    }

    func prepareloadVideo() {
        print("prepareloadVideo")
    }
}


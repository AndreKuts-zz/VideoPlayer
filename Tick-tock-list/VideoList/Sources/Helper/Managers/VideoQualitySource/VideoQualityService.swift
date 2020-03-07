//
//  VideoQualityService.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/28/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

typealias VideoQualityCallback = (_ videoQuality: VideoQuality) -> Void

final class VideoSourceSelectorService: VideoSourceSelectorServiceProtocol {

    private struct Constant {
        static let minKilobytesForMP4: Double = 440.0
        static let url = URL(string: "https://276005.selcdn.ru/videos/h264/0c7fe536bf0e65f90af96fa56b414c31.mp4")
    }

    var onVideoQualityReceivedCallback:  VideoQualityCallback?
    private var internetSpeedTester: InternetSpeedTesterProtocol?

    func makeRequestVideoQuality() {
        setupInternetSpeedTesterIfNeeded()
        internetSpeedTester?.startSpeedTracking()
    }

    private func setupInternetSpeedTesterIfNeeded() {
        guard internetSpeedTester == nil,
            let url = Constant.url else {
                return
        }

        internetSpeedTester = InternetSpeedTester(url: url,
                                                  speedTestCompletionBlock: { [weak self] error, speed in
                                                    self?.receivedCallbackWith(speed: speed, error: error)
        })
    }

    private func receivedCallbackWith(speed: Double?, error: Error?) {
        if error == nil,
            let speed = speed,
            speed > Constant.minKilobytesForMP4 {
            self.onVideoQualityReceivedCallback?(.high)
        } else {
            self.onVideoQualityReceivedCallback?(.low)
        }
    }
}

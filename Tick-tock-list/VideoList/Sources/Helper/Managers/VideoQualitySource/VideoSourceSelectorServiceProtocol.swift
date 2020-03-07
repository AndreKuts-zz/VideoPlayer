//
//  VideoSourceSelectorServiceProtocol.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/28/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

protocol VideoSourceSelectorServiceProtocol {

    var onVideoQualityReceivedCallback: VideoQualityCallback? { get set }

    func makeRequestVideoQuality()
}

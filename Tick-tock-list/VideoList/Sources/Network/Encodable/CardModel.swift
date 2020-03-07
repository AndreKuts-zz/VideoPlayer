//
//  CardModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

struct CardModel: Equatable, Codable {

    let id, type: String
    let order: Int
    let text: String?
    let color: Int
    let showTimelines: Bool?
    let timelines: [TimeLineModel]?
    let isSeen: Bool
    let video: VideoModel?
    let photo: PhotoModel?

    enum CodingKeys: String, CodingKey {
        case id, type, order, text, color
        case showTimelines = "show_timelines"
        case timelines
        case isSeen = "is_seen"
        case video, photo
    }
}

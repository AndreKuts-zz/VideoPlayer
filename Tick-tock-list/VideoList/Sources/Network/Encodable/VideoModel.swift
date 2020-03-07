//
//  VideoModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

struct VideoModel: Equatable, Codable {

    let id, duration: String
    let withSound: Bool
    let width, height: Int
    let firstFrame800, firstFrame320, firstFrame160, firstFrame130: String
    let bluredFrame: String?
    let previewVideo: String
    let rotate, fileSizeMp4: Int
    let files: FileTypesModel
    let iosFrontal, hlsReady: Bool
    let avgColor: String

    enum CodingKeys: String, CodingKey {
        case id, duration
        case withSound = "with_sound"
        case width, height
        case firstFrame800 = "first_frame_800"
        case firstFrame320 = "first_frame_320"
        case firstFrame160 = "first_frame_160"
        case firstFrame130 = "first_frame_130"
        case bluredFrame = "blured_frame"
        case previewVideo = "preview_video"
        case rotate
        case fileSizeMp4 = "file_size_mp4"
        case files
        case iosFrontal = "ios_frontal"
        case hlsReady = "hls_ready"
        case avgColor = "avg_color"
    }
}

//
//  PhotoModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

struct PhotoModel: Equatable, Codable {

    let id: String
    let previewURL, url: String
    let width, height: Int

    enum CodingKeys: String, CodingKey {
        case id
        case previewURL = "preview_url"
        case url, width, height
    }
}

//
//  UserModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

struct UserModel: Equatable, Codable {

    let distance: Double
    let age: Int
    let emotion: String?
    let gender: Gender
    let id, name: String
    let cards: [CardModel]
    let targetCardID: String

    enum CodingKeys: String, CodingKey {
        case distance, age, emotion, id, name, gender, cards
        case targetCardID = "target_card_id"
    }
}

extension UserModel {

    var previewPhotoURL: URL? {

        return cards
            .filter { $0.photo != nil }
            .map { URL(string: $0.video?.firstFrame800 ?? "")}
            .filter { $0 != nil }
            .map { $0! }.first
    }
}

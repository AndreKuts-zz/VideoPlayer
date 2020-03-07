//
//  UserListModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

struct UserListModel: Equatable, Decodable {

    let users: [UserModel]

    enum CodingKeys: String, CodingKey {
        case users
    }
}

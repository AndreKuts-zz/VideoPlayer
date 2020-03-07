//
//  TimeLineModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/27/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

struct TimeLineModel: Equatable, Codable {
    let id: Int
    let start, finish: Double
    let category: Category
}

enum Category: String, Equatable, Codable {
    case interview = "interview"
}

enum Gender: String, Equatable, Codable {
    case female = "female"
}

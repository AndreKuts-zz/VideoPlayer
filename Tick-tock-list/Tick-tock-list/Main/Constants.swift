//
//  Constants.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation

internal struct Constants {

    static var serverURL: URL {
        guard let url = URL(string: "https://codebeautify.org") else {
            fatalError("Server side must have a valid url!")
        }
        return url
    }

    static var queryHeaders: [String: Any] {
        return ["Content-type": "application/json"]
    }
}

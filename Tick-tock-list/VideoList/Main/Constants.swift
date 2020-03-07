//
//  Constants.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Foundation.NSURL
import CoreMedia.CMTime
import CoreGraphics

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

    struct Inset {

        static let bottom: CGFloat = -48
        static let right: CGFloat = -12
        static let between: CGFloat = -8

        struct PlayButton {
            static let vertical: CGFloat = 100
            static let horizotal: CGFloat = 50
        }
    }

    struct Size {

        struct Button {
            static let defaultWidth: CGFloat = 50
            static let defaultHeight: CGFloat = 50
        }

        struct Label {
            static let height: CGFloat = 22
        }
    }

    struct Fonts {
        static let size: CGFloat = 18
    }

    static let defaultCurrentPreferredPeakBitRate: Double = 1000000.0
    static let assetKeys = ["playable", "hasProtectedContent"]
    static let periodicPlayerObesrvervingTimeInterval: CMTime = CMTimeMake(value: 2, timescale: 2)
}

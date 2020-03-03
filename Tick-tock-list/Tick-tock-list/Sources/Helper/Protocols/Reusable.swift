//
//  Reusable.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public typealias NibReusable = Reusable & NibLoadable

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

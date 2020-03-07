//
//  SectionModel.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import RxDataSources

struct SectionModel<Type> {

    typealias T = Type

    var items: [T]

    func selectedItem(at index: Int) -> T? {
        guard items.count <= index else {
            return nil
        }

        return items[index]
    }
}

extension SectionModel: SectionModelType {

    typealias Item = T

    init(original: SectionModel, items: [T]) {
        self = original
        self.items = items
    }
}

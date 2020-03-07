//
//  UICollectionView+IndexPath.swift
//  VideoList
//
//  Created by Kuts, Andrey on 3/5/20.
//  Copyright © 2020 Kuts, Andrey. All rights reserved.
//

import UIKit

extension UICollectionView {

    var indexPathCentralVisibleCell: IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return indexPathForItem(at: visiblePoint)
    }
}

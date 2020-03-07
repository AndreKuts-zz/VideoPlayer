//
//  ViewsFabric.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/29/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit

struct ViewsFabric {

    static private let screenSize = CGSize(width: UIScreen.main.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height + UIApplication.shared.statusBarFrame.height)

    static private var frame = CGRect(origin: UIScreen.main.bounds.origin, size: screenSize)

    static func makeVideoView(frame: CGRect = frame) -> VideoView {
        let videoView = VideoView(frame: frame)
        videoView.backgroundColor = .clear
        return videoView
    }

    static func makeButtonWith(image: UIImage? = nil) -> UIButton {
        let button = makeBackgroundedButton()
        button.setImage(image, for: .normal)
        return button
    }

    static func makeBackgroundedButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        button.layer.cornerRadius = 8
        return button
    }

    static func makeLabelWithShadow(font: UIFont = UIFont.systemFont(ofSize: Constants.Fonts.size)) -> UILabel {
        let label = UILabel()
        label.font = font
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowRadius = 2
        label.layer.masksToBounds = false
        label.layer.shadowOpacity = 0.2
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .left
        return label
    }

    static func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        return imageView
    }

    static func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        return collectionView
    }

    static func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = screenSize
        return layout
    }
}

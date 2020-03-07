//
//  NodesFabric.swift
//  VideoList
//
//  Created by Kuts, Andrey on 3/4/20.
//  Copyright © 2020 Kuts, Andrey. All rights reserved.
//

import AsyncDisplayKit

struct NodesFabric {

    static func makeASCollectionNode() -> ASCollectionNode {
        let collectionNode = ASCollectionNode(frame: .zero, collectionViewLayout: ViewsFabric.makeCollectionViewFlowLayout())
        collectionNode.backgroundColor = .green
        collectionNode.automaticallyManagesSubnodes = true
        collectionNode.view.isPagingEnabled = true
        return collectionNode
    }

    static func makeButtonNode(withImage image: UIImage? = nil) -> ASButtonNode {
        let button = makeBackgroundButtonNode()
        button.setImage(image, for: .normal)
        return button
    }

    static func makeBackgroundButtonNode() -> ASButtonNode {

        let button = ASButtonNode()

        button.setTitle("Button Title Normal", with: nil, with: .blue, for: .normal)
        DispatchQueue.main.async {
            button.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            button.layer.cornerRadius = 8
        }
        return button
    }

    static func makeLabelNode() -> ASTextNode {

        let textNode = ASTextNode()

        DispatchQueue.main.async {
            textNode.shadowColor = UIColor.black.cgColor
            textNode.shadowOffset = CGSize(width: 1.0, height: 1.0)
            textNode.layer.masksToBounds = false
            textNode.layer.shadowRadius = 2
            textNode.layer.shadowOpacity = 0.2
        }

        return textNode
    }

    static func makeImageNode() -> ASImageNode {
        let imageNode = ASImageNode()
        return imageNode
    }

    static func makeVideoNode() -> ASVideoNode {
        let videoNode = ASVideoNode()
        DispatchQueue.main.async {
            videoNode.backgroundColor = .clear
        }
        return videoNode
    }
}

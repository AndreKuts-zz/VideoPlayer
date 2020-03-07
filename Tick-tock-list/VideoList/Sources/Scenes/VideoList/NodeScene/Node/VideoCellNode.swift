//
//  VideoCellNode.swift
//  VideoList
//
//  Created by Kuts, Andrey on 1/7/20.
//  Copyright © 2020 Kuts, Andrey. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

class VideoCellNode: ASCellNode {

    typealias Node = VideoCellNode

    private lazy var playButton = ASButtonNode()
    private lazy var profileButton = NodesFabric.makeButtonNode(withImage: UIImage(named: "profile"))
    private lazy var likeButton = NodesFabric.makeButtonNode(withImage:  UIImage(named: "like"))
    private lazy var messageButton = NodesFabric.makeButtonNode(withImage: UIImage(named: "message"))
    private lazy var titleLabel = NodesFabric.makeLabelNode()
    private lazy var infoLabel = NodesFabric.makeLabelNode()
    private lazy var previewImageView = NodesFabric.makeImageNode()

    let text1 = ASTextNode()
    let text2 = ASTextNode()
    let text3 = ASTextNode()
    let text4 = ASTextNode()

    private var model: VideoCellModelProtocol
    private var disposeBug = DisposeBag()

    init(model: VideoCellModelProtocol) {
        self.model = model
        super.init()

        setupUI()
        self.configureRx()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        profileButton.style.flexShrink = 1.0
        profileButton.style.flexGrow = 1.0

        text2.style.flexShrink = 1.0
        text2.style.flexGrow = 1.0

//        let headerStackSpec = ASWrapperLayoutSpec(layoutElement: videoView)
//        return headerStackSpec

      return ASStackLayoutSpec(
          direction: .horizontal,
          spacing: 16,
          justifyContent: .center,
          alignItems: .center,
          children: [text2])
      }

    // MARK: - LayoutSpec
}

private extension VideoCellNode {

    func setupUI() {
        DispatchQueue.main.async {
            self.selectionStyle = .none
            self.backgroundColor = .green
            self.automaticallyManagesSubnodes = true

            self.addSubnode(self.titleLabel)
//            self.addSubnode(self.videoView)

            self.titleLabel.attributedText = NSAttributedString(string: self.model.title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25),
                                                                                                       NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }

    func configureRx() {
    }
}

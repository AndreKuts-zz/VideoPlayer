//
//  VideoListNodeController.swift
//  VideoList
//
//  Created by Kuts, Andrey on 1/7/20.
//  Copyright © 2020 Kuts, Andrey. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

class VideoListNodeController: ASViewController<ASCollectionNode> {

    typealias T = VideoCellModel

    private var items: [T] = []
    private var context = ASBatchContext()
    private let disposeBag = DisposeBag()

    var viewModel: VideoListNodeModel

    init(viewModel: VideoListNodeModel) {
        let collectionNode = NodesFabric.makeASCollectionNode()
        self.viewModel = viewModel
        super.init(node: collectionNode)

        self.node.leadingScreensForBatching = 1.0
        self.node.delegate = self
        self.node.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureRx()
        viewModel.loadData()
    }
}

private extension VideoListNodeController {

    func configureRx() {
//        self.viewModel.itemDriver
//            .asObservable()
//            .subscribe(onNext: { [weak self] items in
//                guard let self = self else { return }
//                let updateIndexPaths = items.enumerated()
//                    .map { IndexPath(row: self.items.count - 1 + $0.0, section: 0) }
//                self.items.append(contentsOf: items)
//                self.node.insertItems(at: updateIndexPaths)
//                self.context.completeBatchFetching(true)
//            }, onError: { [weak self] _ in
//                guard let self = self else { return }
//                self.context.completeBatchFetching(true)
//            })
//            .disposed(by: disposeBag)
    }
}

// MARK: - ASCollectionDelegate
extension VideoListNodeController: ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.context = context
//        self.viewModel.loadUserList()
    }

    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return !self.context.isFetching()
    }
}

// MARK: - ASCollectionDataSource
extension VideoListNodeController: ASCollectionDataSource {

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalItemCount
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard self.items.count > indexPath.row else { return ASCellNode() }
            return VideoCellNode(model: self.items[indexPath.row])
        }
    }
}

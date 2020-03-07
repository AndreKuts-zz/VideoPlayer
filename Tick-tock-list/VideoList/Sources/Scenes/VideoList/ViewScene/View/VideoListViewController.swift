//
//  VideoListViewController.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit
import Differentiator
import RxDataSources
import RxSwift

class VideoListViewController: UIViewController {

    private lazy var collectionView = ViewsFabric.makeCollectionView()
    private lazy var dataSource = makeDataSource()
    private var disposeBug = DisposeBag()

    var viewModel: VideoListViewModel

    init(viewModel: VideoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureRx()
        viewModel.loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.playCentralVisibleCell()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}

private extension VideoListViewController {

    func setupUI() {
        setupCollectionView()
    }

    func configureRx() {

        viewModel.sectionsDriver
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBug)

        collectionView.rx
            .didEndDecelerating
            .delaySubscription( .seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in self?.playCentralVisibleCell() })
            .disposed(by: disposeBug)
    }

    func makeDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<VideoCellModel>> {
        return RxCollectionViewSectionedReloadDataSource(
            configureCell: { dataSource, collectionView, index, element -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoViewCell.reuseIdentifier, for: index)
                if let videoCell = cell as? VideoViewCell {
                    videoCell.setupUI()
                    videoCell.configure(withModel: element)
                }
                return cell
        })
    }

    func setupCollectionView() {
        collectionView.register(VideoViewCell.self, forCellWithReuseIdentifier: VideoViewCell.reuseIdentifier)
        self.view.addSubview(collectionView)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pinEdges(to: self.view)
    }

    func playCentralVisibleCell() {
        guard let indexPath = collectionView.indexPathCentralVisibleCell else {
            return
        }
        viewModel.playVideo(at: indexPath)
    }
}

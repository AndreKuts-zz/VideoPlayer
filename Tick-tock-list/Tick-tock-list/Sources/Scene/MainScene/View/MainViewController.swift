//
//  MainViewController.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit
import Differentiator
import RxDataSources
import RxSwift

class MainViewController: UIViewController {

    private lazy var collectionView = ViewBuilder.makeCollectionView()
    private lazy var dataSource = makeDataSource()

    private var disposeBug = DisposeBag()

    var viewModel: MainSceneViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureRx()
        viewModel.loadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPlayingVideoOnCurrentCell()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}

private extension MainViewController {

    func setupUI() {
        setupCollectionView()
    }

    func configureRx() {

        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBug)

        (collectionView as UIScrollView).rx
            .didEndDecelerating.throttle(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.setPlayingVideoOnCurrentCell()
            }).disposed(by: disposeBug)
    }

    func makeDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<VideoCellModel>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel>(
            configureCell: { [weak self] dataSource, collectionView, index, element -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: index) as? VideoCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.prepareVideo(forPlayer: self?.viewModel.playerManager.queuePlayer)
                cell.onPlayButoonPresed = {
                    self?.viewModel.playerManager.onPlayButtonPressed()
                }
                cell.setupUI()
                cell.configure(withModel: element)
                return cell
        })
    }

    func setupCollectionView() {
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.reuseIdentifier)
        self.view.addSubview(collectionView)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pinEdges(to: self.view)
    }

    func setPlayingVideoOnCurrentCell() {
        var visibleRect = CGRect()
        visibleRect.origin = self.collectionView.contentOffset
        visibleRect.size = self.collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.collectionView.indexPathForItem(at: visiblePoint),
            let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell else {
                return
        }
        viewModel.playerManager.set(cell.getAsset())
        cell.setupPlayer(with: viewModel.playerManager.player)
        cell.setupPlayLayer()
    }
}

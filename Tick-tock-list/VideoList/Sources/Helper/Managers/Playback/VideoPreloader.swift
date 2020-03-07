//
//  VideoPreloader.swift
//  VideoList
//
//  Created by Kuts, Andrey on 1/2/20.
//  Copyright © 2020 Kuts, Andrey. All rights reserved.
//

import AVFoundation
import RxSwift

struct VideoPreloader {

    func loadUrl(videoURL: URL) -> Single<AVPlayerItem> {
        return Single.create { observable -> Disposable in
            let asset = AVAsset(url: videoURL)
            _ = asset.observe(\AVURLAsset.isPlayable, options: [.new, .initial]) { urlAsset, _ in
                guard urlAsset.isPlayable else {
                    observable(.error(NetworkingError.defaultError)) // TODO: Add correct error
                    return
                }
                asset.loadValuesAsynchronously(forKeys: Constants.assetKeys) {
                    let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: Constants.assetKeys)
                    observable(.success(playerItem))
                }
            }
            return Disposables.create()
        }
    }
}

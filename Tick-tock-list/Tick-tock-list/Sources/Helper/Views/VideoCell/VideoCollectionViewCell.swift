//
//  VideoCollectionViewCell.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import AVFoundation

private struct Constant {
    
}

class VideoCollectionViewCell: UICollectionViewCell, Reusable {

    private var playButton = UIButton()
    private var profileButton = ViewBuilder.makeButtonWith(image: UIImage(named: "profile"))
    private var likeButton = ViewBuilder.makeButtonWith(image: UIImage(named: "like"))
    private var messageButton = ViewBuilder.makeButtonWith(image: UIImage(named: "message"))
    private var titleLabel = ViewBuilder.makeLabelWithShadow()
    private var infoLabel = ViewBuilder.makeLabelWithShadow(font: UIFont.boldSystemFont(ofSize: 18))
    private var previewImageView = ViewBuilder.makeImageView()

    private var videoView = ViewBuilder.makeVideoView()
    private var model: VideoCellModel?

    var onPlayButoonPresed: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subviews.forEach { $0.removeFromSuperview() }
    }

    func configure(withModel model: VideoCellModel) {
        self.model = model
//        titleLabel.text = "\(model.user.age) years"
//        infoLabel.text = model.user.name
//        if let urlString = model.user.cards.first?.video?.firstFrame800,
//            let url = URL(string: urlString) {
//            previewImageView.kf.setImage(with: url) // TODO: Add preload imag
//        } else {
//            // TODO show defult image
//        }
    }

    func setupUI() {
        setupPreviewImageView()
        setupVideoView()
        setupTitleLabel()
        setupInfoLabel()
        setProfileButton()
        setMessageButton()
        setLikeButton()
    }

    func prepareVideo(forPlayer player: AVQueuePlayer?) {
        guard let asset = getAsset() else { return }
        let playerItem = AVPlayerItem(asset: asset)
        player?.insert(playerItem, after: nil)
        model?.prepareloadVideo()
    }

    func getAsset() -> AVAsset? {
        guard let url = model?.getAssetUrl() else {
            return nil
        }
        return AVAsset(url: url)
    }

    func setupPlayer(with player: AVPlayer) {
        let playerLayer = AVPlayerLayer(player: player)
        videoView.setupMovieView(withPlayerLayer: playerLayer)
        setupPlayButton()
    }

    func setupPlayLayer() {
        videoView.setupPlayLayer()
        previewImageView.image = nil
    }
}

private extension VideoCollectionViewCell {

    func setupTitleLabel() {
        titleLabel.removeFromSuperview()
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: frame.size.width - 24).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        titleLabel.font = UIFont.systemFont(ofSize: 18)
    }

    func setupPreviewImageView() {
        previewImageView.removeFromSuperview()
        self.addSubview(previewImageView)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        previewImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    func setupVideoView() {
        videoView.removeFromSuperview()
        self.addSubview(videoView)
        videoView.backgroundColor = .clear
    }

    func setupInfoLabel() {
        infoLabel.removeFromSuperview()
        self.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalToConstant: frame.size.width - 24).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    func setupPlayButton() {
        playButton.removeFromSuperview()
        self.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
        playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        playButton.setImage(UIImage(named: "play"), for: .selected)
        playButton.addTarget(self, action: #selector(onPlayButtonPressed), for: .touchUpInside)
        playButton.isSelected = false
    }

    func setProfileButton() {
        profileButton.removeFromSuperview()
        self.addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48).isActive = true
        profileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setLikeButton() {
        likeButton.removeFromSuperview()
        self.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.bottomAnchor.constraint(equalTo: messageButton.topAnchor, constant: -8).isActive = true
        likeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setMessageButton() {
        messageButton.removeFromSuperview()
        self.addSubview(messageButton)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.bottomAnchor.constraint(equalTo: profileButton.topAnchor, constant: -8).isActive = true
        messageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc func onPlayButtonPressed(sender: UIButton) {
        // TODO: bind model isVideoPlaing state with button and icon
        onPlayButoonPresed?()
        sender.isSelected.toggle()
    }
}

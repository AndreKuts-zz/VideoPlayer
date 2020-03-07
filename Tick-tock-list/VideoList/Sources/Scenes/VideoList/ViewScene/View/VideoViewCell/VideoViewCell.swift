//
//  VideoViewCell.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/25/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import AVFoundation

class VideoViewCell: UICollectionViewCell, Reusable {

    private var playButton = UIButton()
    private var profileButton = ViewsFabric.makeButtonWith(image: UIImage(named: "profile"))
    private var likeButton = ViewsFabric.makeButtonWith(image: UIImage(named: "like"))
    private var messageButton = ViewsFabric.makeButtonWith(image: UIImage(named: "message"))
    private var titleLabel = ViewsFabric.makeLabelWithShadow()
    private var infoLabel = ViewsFabric.makeLabelWithShadow(font: UIFont.boldSystemFont(ofSize: Constants.Fonts.size))
    private var previewImageView = ViewsFabric.makeImageView()
    private var model: VideoCellModelProtocol?
    private var videoView = ViewsFabric.makeVideoView()
    private var disposeBug = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBug = DisposeBag()
    }
}

// MARK: - VideoViewCellProtocol

extension VideoViewCell: VideoViewCellProtocol {

    func setupUI() {
        setupPreviewImageView()
        setupTitleLabel()
        setupInfoLabel()
        setProfileButton()
        setMessageButton()
        setLikeButton()
        setupVideoView()
    }

    func configure(withModel model: VideoCellModelProtocol) {
        self.model = model
        self.titleLabel.text = model.title
        self.infoLabel.text = model.info
        self.configurePreviewImage(model.previewImageURL)

        if let player = model.videoPlyaer.value {
            DispatchQueue.main.async { self.setVideoPlyaer(player) }
        } else {
            self.configureRx()
        }
    }
}

private extension VideoViewCell {

    func configureRx() {
        model?.videoPlyaer
            .subscribe(onNext: { [weak self] player in self?.setVideoPlyaer(player) })
            .disposed(by: disposeBug)
    }

    func setVideoPlyaer(_ player: AVPlayer?) {
        player?.seek(to: .zero)
        videoView.player = player
        setupPlayButton()
    }

    func configurePreviewImage(_ imageURL: URL?) {
        if let url = imageURL {
            previewImageView.kf.setImage(with: url)
        } else {
            previewImageView.image = nil // TODO: Set default image
        }
    }

    func setupTitleLabel() {
        titleLabel.removeFromSuperview()
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.Inset.bottom).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: frame.size.width - 24).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Constants.Size.Label.height).isActive = true
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
        DispatchQueue.main.async {
            self.videoView = ViewsFabric.makeVideoView()
            self.addSubview(self.videoView)
        }
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
        playButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Inset.PlayButton.vertical).isActive = true
        playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Inset.PlayButton.vertical).isActive = true
        playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Inset.PlayButton.horizotal).isActive = true
        playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Inset.PlayButton.horizotal).isActive = true
        playButton.setImage(UIImage(named: "play"), for: .selected)
        playButton.addTarget(self, action: #selector(onPlayButtonPressed), for: .touchUpInside)
        playButton.isSelected = false
    }

    @objc func onPlayButtonPressed(_ sender: UIButton) {
        model?.playbackManager.onPlayButtonPressed(isPlay: sender.isSelected)
        sender.isSelected.toggle()
    }

    func setProfileButton() {
        profileButton.removeFromSuperview()
        self.addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.Inset.bottom).isActive = true
        profileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.Inset.right).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: Constants.Size.Button.defaultWidth).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: Constants.Size.Button.defaultHeight).isActive = true
    }

    func setLikeButton() {
        likeButton.removeFromSuperview()
        self.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.bottomAnchor.constraint(equalTo: messageButton.topAnchor, constant: Constants.Inset.between).isActive = true
        likeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.Inset.right).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: Constants.Size.Button.defaultWidth).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: Constants.Size.Button.defaultHeight).isActive = true
    }

    func setMessageButton() {
        messageButton.removeFromSuperview()
        self.addSubview(messageButton)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.bottomAnchor.constraint(equalTo: profileButton.topAnchor, constant: Constants.Inset.between).isActive = true
        messageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.Inset.right).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: Constants.Size.Button.defaultWidth).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: Constants.Size.Button.defaultHeight).isActive = true
    }
}

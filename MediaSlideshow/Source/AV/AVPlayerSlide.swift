//
//  AVSlideshowItem.swift
//  ImageSlideshow
//
//  Created by Peter Meyers on 1/5/21.
//

import AVFoundation
import AVKit
import UIKit

public protocol AVPlayerSlideDelegate: AnyObject {
    func currentThumbnail(_ slide: AVPlayerSlide) -> UIImage?
    func slideDidAppear(_ slide: AVPlayerSlide)
    func slideDidDisappear(_ slide: AVPlayerSlide)
}

public class AVPlayerSlide: UIView, MediaSlideshowSlide {
    weak var delegate: AVPlayerSlideDelegate?

    public var cornerRadius: CGFloat = 0 {
        didSet {
            playerController.view.layer.cornerRadius = cornerRadius
            playerController.view.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }

    public let playerController: AVPlayerViewController
    private let transitionView: UIImageView

    public init(
        playerController: AVPlayerViewController,
        mediaContentMode: UIView.ContentMode) {
        self.playerController = playerController
        self.mediaContentMode = mediaContentMode
        self.transitionView = UIImageView()
        super.init(frame: .zero)
        setPlayerViewVideoGravity()
        // Stays hidden, but needs to be apart of the view heirarchy due to how the zoom animation works.
        transitionView.isHidden = true
        embed(transitionView)
        embed(playerController.view)
        if playerController.showsPlaybackControls {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSingleTap)))
        }
        self.backgroundColor = .clear
        playerController.view.backgroundColor = .clear
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPlayerViewVideoGravity() {
        switch mediaContentMode {
        case .scaleAspectFill: playerController.videoGravity = .resizeAspectFill
        case .scaleToFill: playerController.videoGravity = .resize
        default: playerController.videoGravity = .resizeAspect
        }
    }

    // MARK: - MediaSlideshowSlide

    public var mediaContentMode: UIView.ContentMode {
        didSet {
            setPlayerViewVideoGravity()
        }
    }

    public func willBeRemoved() {
        playerController.player?.pause()
    }

    public func loadMedia() {}

    public func releaseMedia() {}

    public func transitionImageView() -> UIImageView {
        transitionView.frame = playerController.videoBounds
        transitionView.contentMode = mediaContentMode
        transitionView.image = delegate?.currentThumbnail(self)
        return transitionView
    }

    public func didAppear() {
        delegate?.slideDidAppear(self)
    }

    public func didDisappear() {
        delegate?.slideDidDisappear(self)
    }

    @objc
    private func didSingleTap() {}
}

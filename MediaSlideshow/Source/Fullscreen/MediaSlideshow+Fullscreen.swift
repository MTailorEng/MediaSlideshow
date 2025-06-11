//
//  MediaSlideshow+Fullscreen.swift
//  MediaSlideshow_framework
//
//  Created by Peter Meyers on 1/19/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension MediaSlideshow {
    /**
     Open full screen slideshow
     - parameter controller: Controller to present the full screen controller from
     - returns: FullScreenSlideshowViewController instance
     */
    @discardableResult
    open func presentFullScreenController(from controller: UIViewController, completion: (() -> Void)? = nil) -> FullScreenSlideshowViewController {
        let fullscreen = FullScreenSlideshowViewController()
        fullscreen.pageSelected = {[weak self] (page: Int) in
            self?.setCurrentPage(page, animated: false)
        }

        fullscreen.initialPage = currentPage
        fullscreen.setMediaSources(sources)
        slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: self, slideshowController: fullscreen)
        fullscreen.transitioningDelegate = slideshowTransitioningDelegate
        fullscreen.modalPresentationStyle = .custom
        controller.present(fullscreen, animated: true, completion: completion)
        return fullscreen
    }
}

import UIKit
import ImageIO

/// Input Source to load HEIC images from local files
@objcMembers
open class HEICImageSource: NSObject, ImageSource {
    var path: String?
    var imageName: String?
    
    /// Initializes a new source with a path to a HEIC image
    /// - parameter path: path to the HEIC image file
    public init(path: String) {
        self.path = path
        super.init()
    }
    
    /// Initializes a new source with an image name from the main bundle
    /// - parameter imageName: name of the HEIC file in the application's main bundle
    public init?(imageName: String) {
        guard let path = Bundle.main.path(forResource: imageName, ofType: "heic") else {
            return nil
        }
        self.path = path
        self.imageName = imageName
        super.init()
    }
    
    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        if let path = path, let image = loadHEICImage(from: path) {
            imageView.image = image
            callback(image)
        } else {
            callback(nil)
        }
    }
    
    public func cancelLoad(on imageView: UIImageView) {
        // No-op for local images
    }
    
    private func loadHEICImage(from path: String) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil) else {
            return nil
        }
        
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 2048
        ] as CFDictionary
        
        guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {
            return nil
        }
        
        return UIImage(cgImage: thumbnail)
    }
} 
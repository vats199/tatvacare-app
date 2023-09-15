//
//  GExtension+UIImageView.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit
import ImageIO
//import SimpleImageViewer
import SDWebImage
import ImageViewer_swift


extension UIImageView {
    
    /// Sets image from image URL.
    /// - Parameters:
    ///   - url: Image URL
    ///   - placeholder: Placeholder image
    ///   - loader: Flag for show loader or not
    ///   - completed: Completion block after download image
    //UIImage(named: "defaultUser")
    func setCustomImage(with url: String,
                        placeholder: UIImage? = UIImage(),
                        andLoader loader: Bool = true,
                        renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysOriginal,
                        completed: SDExternalCompletionBlock? = nil) {
        
        self.image = UIImage()
        guard let imageURL = URL(string: url) else {
            if let img = placeholder {
                self.image = img
            }
            else {
                self.image = UIImage()
            }
            return
        }
        
        //print("url--",imageURL)
        sd_imageTransition = .fade
        
        if loader {
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
        
        if renderingMode == .alwaysOriginal {
            sd_setImage(with: imageURL, placeholderImage: placeholder, options:[.retryFailed, .refreshCached, .continueInBackground, .waitStoreCache], completed: completed)
        }
        else {
            //            SDImageCache.shared.clearMemory()
            //            SDImageCache.shared.clearDisk()
            //            SDImageCache.shared.config.diskCacheExpireType = false
            sd_setImage(with: imageURL, placeholderImage: placeholder, options:[.retryFailed, .continueInBackground, .waitStoreCache, .refreshCached]){ img, err, cache, url in
                
                
                self.image = img?.withRenderingMode(renderingMode)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0){
                    if let _ = img {
                        self.image = img?.withRenderingMode(renderingMode)
                    }
                }
            }
        }
    }
    
    /**
     Tap to open full screen image preview
     - Parameter image: UIImage for preview
     */
    func tapToZoom(with image: UIImage? = nil) {
        if let img = image {
            self.setupImageViewer(images: [img])
            
//            self.addTapGestureRecognizer {
//                self.zoomImage(with: image)
//            }
        }
    }
    
    /**
     Full screen image preview
     - Parameter image: UIImage for preview
     */
    func zoomImage(with image: UIImage?) {
        
        if let _ = image {
            let configuration = ImageViewerConfiguration { config in
                config.imageView = self
                if image != nil {
                    config.image = image
                }
            }

            let imageViewerController = ImageViewerController(configuration: configuration)
            imageViewerController.navigationController?.navigationBar.isHidden = false
            UIApplication.topViewController()?.present(imageViewerController, animated: true, completion: nil)
        }
    }
    
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

@IBDesignable
class AlignedAspectFitImageView: UIImageView {
    
    enum HorizontalAlignment: String {
        case left, center, right
    }
    
    enum VerticalAlignment: String {
        case top, center, bottom
    }
    
    private var theImageView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    @IBInspectable override var image: UIImage? {
        get { return theImageView.image }
        set {
            theImageView.image = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable var hAlign: String = "center" {
        willSet {
            // Ensure user enters a valid alignment name while making it lowercase.
            if let newAlign = HorizontalAlignment(rawValue: newValue.lowercased()) {
                horizontalAlignment = newAlign
            }
        }
    }
    
    @IBInspectable var vAlign: String = "center" {
        willSet {
            // Ensure user enters a valid alignment name while making it lowercase.
            if let newAlign = VerticalAlignment(rawValue: newValue.lowercased()) {
                verticalAlignment = newAlign
            }
        }
    }
    
    @IBInspectable var aspectFill: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var horizontalAlignment: HorizontalAlignment = .center
    var verticalAlignment: VerticalAlignment = .center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    func commonInit() -> Void {
        clipsToBounds = true
        addSubview(theImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let img = theImageView.image else {
            return
        }
        
        DispatchQueue.main.async {
            
            var newRect = self.bounds
            
            let viewRatio = self.bounds.size.width / self.bounds.size.height
            let imgRatio = img.size.width / img.size.height
            
            // if view ratio is equal to image ratio, we can fill the frame
            if viewRatio == imgRatio {
                self.theImageView.frame = newRect
                return
            }
            
            // otherwise, calculate the desired frame

            var calcMode: Int = 1
            if self.aspectFill {
                calcMode = imgRatio > 1.0 ? 1 : 2
            } else {
                calcMode = imgRatio < 1.0 ? 1 : 2
            }

            if calcMode == 1 {
                // image is taller than wide
                let heightFactor = self.bounds.size.height / img.size.height
                let w = img.size.width * heightFactor
                newRect.size.width = w
                switch self.horizontalAlignment {
                case .center:
                    newRect.origin.x = (self.bounds.size.width - w) * 0.5
                case .right:
                    newRect.origin.x = self.bounds.size.width - w
                default: break  // left align - no changes needed
                }
            } else {
                // image is wider than tall
                let widthFactor = self.bounds.size.width / img.size.width
                let h = img.size.height * widthFactor
                newRect.size.height = h
                switch self.verticalAlignment {
                case .center:
                    newRect.origin.y = (self.bounds.size.height - h) * 0.5
                case .bottom:
                    newRect.origin.y = self.bounds.size.height - h
                default: break  // top align - no changes needed
                }
            }

            self.theImageView.frame = newRect
        }
        
    }
}

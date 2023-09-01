import UIKit
import ImageIO

extension UIImage {
   
    
    /// Resizes an image to the specified size.
    ///
    /// - Parameters:
    ///     - size: the size we desire to resize the image to.
    ///
    /// - Returns: the resized image.
    ///
    
    
    func imageWith(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    func imageWithSize(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height);
        draw(in: rect)
        
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resultingImage
    }
    
    /// Resizes an image to the specified size and adds an extra transparent margin at all sides of
    /// the image.
    ///
    /// - Parameters:
    ///     - size: the size we desire to resize the image to.
    ///     - extraMargin: the extra transparent margin to add to all sides of the image.
    ///
    /// - Returns: the resized image.  The extra margin is added to the input image size.  So that
    ///         the final image's size will be equal to:
    ///         `CGSize(width: size.width + extraMargin * 2, height: size.height + extraMargin * 2)`
    ///
    func imageWithSize(size: CGSize, extraMargin: CGFloat) -> UIImage? {
        
        let imageSize = CGSize(width: size.width + extraMargin * 2, height: size.height + extraMargin * 2)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale);
        let drawingRect = CGRect(x: extraMargin, y: extraMargin, width: size.width, height: size.height)
        draw(in: drawingRect)
        
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resultingImage
    }
    
    /// Resizes an image to the specified size.
    ///
    /// - Parameters:
    ///     - size: the size we desire to resize the image to.
    ///     - roundedRadius: corner radius
    ///
    /// - Returns: the resized image with rounded corners.
    ///
    func imageWithSize(size: CGSize, roundedRadius radius: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: .zero, size: size)
            currentContext.addPath(UIBezierPath(roundedRect: rect,
                                                byRoundingCorners: .allCorners,
                                                cornerRadii: CGSize(width: radius, height: radius)).cgPath)
            currentContext.clip()
            
            //Don't use CGContextDrawImage, coordinate system origin in UIKit and Core Graphics are vertical oppsite.
            draw(in: rect)
            currentContext.drawPath(using: .fillStroke)
            let roundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return roundedCornerImage
        }
        return nil
    }
    
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage: CIImage = ciImage ?? CoreImage.CIImage(cgImage: cgImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGContext(data: &bitmap, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            let inputImage = cgImage ?? CIContext().createCGImage(ciImage!, from: ciImage!.extent)
            
            // Render to bitmap.
            context.draw(inputImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
}

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 500.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}

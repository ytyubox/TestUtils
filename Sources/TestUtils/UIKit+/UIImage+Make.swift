//
/*
 *		Created by 游宗諭 in 2021/1/27
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */
#if canImport(XCTest) && canImport(UIKit)
    import UIKit
    public extension UIImage {
        static func make(withColor color: UIColor) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(color.cgColor)
            context.fill(rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }
    }
#endif

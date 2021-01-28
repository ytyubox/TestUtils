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
    public extension UIView {
        func enforceLayoutCycle() {
            layoutIfNeeded()
            RunLoop.current.run(until: Date())
        }
    }
#endif

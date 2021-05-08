//
/*
 *		Created by 游宗諭 in 2021/5/8
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.3
 */

#if canImport(UIKit)
import UIKit
import XCTest

import TestUtils

final class SnapshotTests: XCTestCase {
    func test() throws {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        let view1 = UILabel(frame: frame)
        view1.text = "3"
        view1.backgroundColor = .white
        view1.textColor = .black
        let view2 = UILabel(frame: frame)
        view2.text = "3"
        view2.backgroundColor = .white
        view2.textColor = .black
        let config = SnapshotConfiguration(style: .dark)
        let image1 = view1.snapshot(for: config)
        let image2 = view2.snapshot(for: config)
        let imagediff = try XCTImageDiff(image1: image1, image2: image2, diffColor: .red)
        XCTAssert(snapshot: imagediff, named: "Image diff", diffColor:   .blue)
    }
}

#endif

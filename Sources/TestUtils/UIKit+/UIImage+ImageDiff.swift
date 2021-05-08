//
/*
 *		Created by 游宗諭 in 2021/5/8
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.3
 */

import Foundation
#if canImport(UIKit)
import UIKit

// MARK: - DiffError

struct DiffError: LocalizedError {
    internal init(_ errorDescription: String?) {
        self.errorDescription = errorDescription
    }

    var errorDescription: String?
}

public func XCTImageDiff(image1: UIImage, image2: UIImage, diffColor: RGBAColor) throws -> UIImage {
    guard let input1CGImage = image1.cgImage else {
        throw DiffError("unable to get cgImage for image 1")
    }
    guard let input2CGImage = image2.cgImage else {
        throw DiffError("unable to get cgImage for image 2")
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard input1CGImage.width == input2CGImage.width,
          input1CGImage.height == input2CGImage.height
    else {
        throw DiffError(
            """
            Image size not the same
            Image 1 size: \(input1CGImage.width) * \(input1CGImage.height)
            Image 2 size: \(input2CGImage.width) * \(input2CGImage.height)
            """
        )
    }
    let width = input1CGImage.width
    let height = input1CGImage.height
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let bytesPerRow = bytesPerPixel * width
    let bitmapInfo = RGBA32.bitmapInfo

    guard
        let context1 = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
        let context2 = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
    else {
        throw DiffError("unable to create context")
    }
    context1.draw(input1CGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    context2.draw(input2CGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

    guard let buffer1 = context1.data,
          let buffer2 = context2.data
    else {
        throw DiffError("unable to get context data")
    }

    let pixelBuffer1 = buffer1.bindMemory(to: RGBA32.self, capacity: width * height)
    let pixelBuffer2 = buffer2.bindMemory(to: RGBA32.self, capacity: width * height)

    for row in 0 ..< Int(height) {
        for column in 0 ..< Int(width) {
            let offset = row * width + column
            if pixelBuffer1[offset] != pixelBuffer2[offset] {
                pixelBuffer1[offset] = diffColor
            }
        }
    }

    let outputCGImage = context1.makeImage()!
    let outputImage = UIImage(cgImage: outputCGImage, scale: image1.scale, orientation: image1.imageOrientation)
    return outputImage
}

// MARK: - RGBA32

public typealias RGBAColor = RGBA32

// MARK: - RGBA32

public struct RGBA32: Equatable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }

    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red = UInt32(red)
        let green = UInt32(green)
        let blue = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }

    public static let red = RGBA32(red: 255, green: 0, blue: 0, alpha: 255)
    public static let green = RGBA32(red: 0, green: 255, blue: 0, alpha: 255)
    public static let blue = RGBA32(red: 0, green: 0, blue: 255, alpha: 255)
    public static let white = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    public static let black = RGBA32(red: 0, green: 0, blue: 0, alpha: 255)
    public static let magenta = RGBA32(red: 255, green: 0, blue: 255, alpha: 255)
    public static let yellow = RGBA32(red: 255, green: 255, blue: 0, alpha: 255)
    public static let cyan = RGBA32(red: 0, green: 255, blue: 255, alpha: 255)

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    public static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
}
#endif

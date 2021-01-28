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
    import XCTest
    public func XCTAssert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }

        if snapshotData != storedSnapshotData {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent("Unexpected-" + snapshotURL.lastPathComponent)

            try? snapshotData?.write(to: temporarySnapshotURL)

            XCTFail("""
            New snapshot does not match stored snapshot.
            expecting snapshot URL:
            \(snapshotURL)
            receieved snapshot URL:
            \(temporarySnapshotURL),
            """, file: file, line: line)
        }
    }

    public func XCTRecord(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            guard let snapshotData = snapshotData else {
                return
            }

            try snapshotData.write(to: snapshotURL)
            #if DEBUG
                XCTFail("Successfully save image snapshot, replace with assert to pass assertion\npath: \(snapshotURL)", file: file, line: line)
            #endif
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(Device.type.rawValue)")
            .appendingPathComponent("\(name)-\(Device.type).png")
    }

    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }

        return data
    }


    public struct SnapshotConfiguration {
        let traitCollection: UITraitCollection

        public init(style: UIUserInterfaceStyle) {
            traitCollection = UITraitCollection(traitsFrom: [
                UITraitCollection(userInterfaceStyle: style),
            ]
            )
        }
    }

    private final class SnapshotWindow: UIWindow {
        private var configuration: SnapshotConfiguration = .init(style: .light)

        convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
            self.init(frame: CGRect(origin: .zero, size: root.view.bounds.size))
            rootViewController = root
            isHidden = false
            self.configuration = configuration
        }

        override var traitCollection: UITraitCollection {
            UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
        }

        func snapshot() -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
            return renderer.image { action in
                layer.render(in: action.cgContext)
            }
        }
    }
public extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}
public extension UIView {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        let root = UIViewController()
        root.view = self
        return SnapshotWindow(configuration: configuration, root: root).snapshot()
    }
}
#endif

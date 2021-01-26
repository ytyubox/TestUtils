import XCTest
public func alwaysFail(file: StaticString = #file, line: UInt = #line) {
    XCTFail(file: file, line: line)
}

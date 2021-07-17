/**
 * Created by 游宗諭 in 2020/12/17
 *
 *
 * Using Swift 5.0
 *
 * Running on macOS 10.15
 */

import XCTest
enum XCTGetIndexError: Error {
    case outofRange
}

public func XCTGetIndex<C, T>(
    _ array: C, with index: C.Index,
    _ message: @autoclosure () -> String = "Index out of range",
    file: StaticString = #file,
    line: UInt = #line
) throws -> T
    where C: RandomAccessCollection, C.Element == T
{
    guard array.indices.contains(index) else {
        XCTFail(message(), file: file, line: line)
        throw XCTGetIndexError.outofRange
    }
    return array[index]
}

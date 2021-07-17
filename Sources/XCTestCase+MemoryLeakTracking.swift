import XCTest

public extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject,
                             _ customMessage: String = "",
                             file: StaticString = #file,
                             line: UInt = #line)
    {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.: \(customMessage)", file: file, line: line)
        }
    }
}

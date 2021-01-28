# TestUtils

## UIKit snapshot

### To save a snapshot.
```swift
let image = view.snapshot()
XCTRecord(snapshot: image: named: "THE_FILE_NAME")
```
> This will save the snapshot as `"#File/snapshots/#Device/THE_FILE_NAME-#DEVICE.png"`, where `#Device` is the destination for test.

### To assert a snapshot.
```swift
let image = view.snapshot()
XCTAssert(snapshot: image: named: "THE_FILE_NAME")
```

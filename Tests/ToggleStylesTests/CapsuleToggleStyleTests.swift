import SnapshotTesting
import XCTest

@testable import ToggleStyles

final class CapsuleToggleStyleTests: XCTestCase {
  func testCapsuleToggleStyle() {
    let toggleStyle = CapsuleToggleStyle_Previews.previews
    assertSnapshot(
      matching: toggleStyle,
      as: .image(layout: .device(config: .iPhone8))
    )
  }
}

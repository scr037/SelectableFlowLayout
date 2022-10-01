import SnapshotTesting
import XCTest

@testable import FlowLayout

final class SelectableHScrollViewTests: XCTestCase {
  func testSelectableHScrollView() {
    let flow = SelectableHScrollView_Previews.previews
    assertSnapshot(
      matching: flow,
      as: .image(layout: .device(config: .iPhone8))
    )
  }
}

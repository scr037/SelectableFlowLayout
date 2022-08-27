import SnapshotTesting
import XCTest

@testable import FlowLayout

final class SelectableFlowLayoutTests: XCTestCase {
  func testSelectableFlowLayout() {

    let flow = SelectableFlowLayout_Previews.previews
    assertSnapshot(
      matching: flow,
      as: .image(layout: .device(config: .iPhone8))
    )
  }
}

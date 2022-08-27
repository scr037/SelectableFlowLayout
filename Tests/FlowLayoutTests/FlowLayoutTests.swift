import SnapshotTesting
import XCTest

@testable import FlowLayout

final class FlowLayoutTests: XCTestCase {
  func testFlowLayout() {

    let flow = FlowLayout_Previews.previews
    assertSnapshot(
      matching: flow,
      as: .image(layout: .device(config: .iPhone8))
    )
  }
}

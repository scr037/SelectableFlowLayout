import SwiftUI

extension View {

  public func capsuleToggleStyle(
    backgroundColor: CapsuleToggleStyle.StatefulColor,
    foregroundColor: CapsuleToggleStyle.StatefulColor,
    strokeColor: CapsuleToggleStyle.StatefulColor,
    action: CapsuleToggleStyle.Action
  ) -> some View {
    self.toggleStyle(
      CapsuleToggleStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        strokeColor: strokeColor,
        action: action
      )
    )
  }
}

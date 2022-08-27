import SwiftUI

public struct CapsuleToggleStyle: ToggleStyle {
  @Environment(\.font) private var font
  
  var backgroundColor: StatefulColor
  var foregroundColor: StatefulColor
  var strokeColor: StatefulColor
  var action: Action
  
  public init(
    backgroundColor: StatefulColor,
    foregroundColor: StatefulColor,
    strokeColor: StatefulColor,
    action: Action
  ) {
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
    self.strokeColor = strokeColor
    self.action = action
  }

  public enum Action {
    case closure(image: Image, action: () -> Void)
    case none
  }
  
  public enum StatefulColor {
    case color(normal: Color, selected: Color)
    
    var selected: Color {
      switch self {
      case .color(_, let selected): return selected
      }
    }
    
    var normal: Color {
      switch self {
      case .color(let normal, _): return normal
      }
    }
  }

  public func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
        .foregroundColor(
          configuration.isOn
          ? foregroundColor.selected
          : foregroundColor.normal
        )
        .font(font)

      switch action {
      case .closure(let image, let action):
        Button(
          action: { action() },
          label: {
            image.foregroundColor(
              configuration.isOn
              ? foregroundColor.selected
              : foregroundColor.normal
            )
          }
        )
      case .none:
        EmptyView()
      }
    }
    .padding(.vertical, 6)
    .padding(.horizontal, 12)
    .background(
      Capsule(style: .circular)
        .fill(
          configuration.isOn
          ? backgroundColor.selected
          : backgroundColor.normal
        )
        .overlay(content: {
          Capsule(style: .circular)
            .stroke(
              configuration.isOn
              ? strokeColor.selected
              : strokeColor.normal,
              lineWidth: configuration.isOn ? 2 : 1
            )
        })
      )
  }
}

struct CapsuleToggleStyle_Previews: PreviewProvider {
  static let capsules: some View =
    VStack {
      Toggle("Hello, world", isOn: .constant(false))
        .environment(\.font, .callout)
        .toggleStyle(CapsuleToggleStyle(
          backgroundColor: .color(normal: .clear, selected: .purple),
          foregroundColor: .color(normal: .gray, selected: .purple),
          strokeColor: .color(normal: .gray, selected: .purple),
          action: .closure(image: Image(systemName: "xmark.circle.fill"), action: {})
        ))
      Toggle("Hello, world", isOn: .constant(true))
        .environment(\.font, .callout)
        .toggleStyle(CapsuleToggleStyle(
          backgroundColor: .color(normal: .clear, selected: .purple),
          foregroundColor: .color(normal: .gray, selected: .white),
          strokeColor: .color(normal: .gray, selected: .purple),
          action: .closure(image: Image(systemName: "xmark.circle.fill"), action: {})
        ))
      Toggle("Hello, world", isOn: .constant(false))
        .environment(\.font, .callout)
        .toggleStyle(CapsuleToggleStyle(
          backgroundColor: .color(normal: .clear, selected: .purple),
          foregroundColor: .color(normal: .gray, selected: .purple),
          strokeColor: .color(normal: .gray, selected: .purple),
          action: .none
        ))
      Toggle("Hello, world", isOn: .constant(true))
        .environment(\.font, .callout)
        .toggleStyle(CapsuleToggleStyle(
          backgroundColor: .color(normal: .clear, selected: .purple),
          foregroundColor: .color(normal: .gray, selected: .white),
          strokeColor: .color(normal: .gray, selected: .purple),
          action: .none
        ))
  }

  static var previews: some View {
    VStack {
      GroupBox { capsules }
    }
  }
}

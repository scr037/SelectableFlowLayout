import SwiftUI

public struct SelectableHScrollView<Content: View>: View {
  // Configuration
  private var isShowSelectionOnTop: Bool
  private var animation: Animation?

  // Content
  @Binding private var elements: [String]
  @Binding private var selectedElements: [String]
  @ViewBuilder private var content: (_ element: String, _ isSelected: Bool) -> Content

  public init(
    elements: Binding<[String]>,
    selectedElements: Binding<[String]>,
    showsSelectionOnTop: Bool = true,
    animation: Animation = .easeIn(duration: 0.2),
    content: @escaping (String, Bool) -> Content
  ) {
    self._elements = elements
    self._selectedElements = selectedElements
    self.isShowSelectionOnTop = showsSelectionOnTop
    self.animation = animation
    self.content = content
  }

  public var body: some View {
    VStack {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(elements, id: \.self) { element in
            Button(
              action: {
                if selectedElements.contains(element) {
                  selectedElements.removeAll { $0 == element }
                } else {
                  selectedElements.append(element)
                }
                if isShowSelectionOnTop {
                  var temp = selectedElements
                  temp.appendUniqueElements(elements)
                  elements = temp
                }
              },
              label: {
                content(
                  element,
                  $selectedElements.wrappedValue.contains(element)
                )
              }
            )
            .animation(animation, value: elements)
            .buttonStyle(.plain)
          }
        }
      }
    }
    .onAppear {
      if isShowSelectionOnTop {
        var temp = $selectedElements.wrappedValue
        temp.appendUniqueElements($elements.wrappedValue)
        $elements.wrappedValue = temp
      }
    }
  }
}

struct SelectableHScrollView_Previews: PreviewProvider {
  @State static var elements = ["avocado", "tomato", "beef", "chicken"]
  @State static var selected = ["avocado"]
  static var previews: some View {
    SelectableHScrollView(
      elements: $elements,
      selectedElements: $selected,
      showsSelectionOnTop: true
    ) { element, isSelected in
      Toggle(element, isOn: .constant(isSelected))
        .environment(\.font, .body)
        .capsuleToggleStyle(
          backgroundColor: .color(normal: .gray, selected: .green),
          foregroundColor: .color(normal: .white, selected: .black),
          strokeColor: .color(normal: .white, selected: .black),
          action: .none
        )
    }
  }
}

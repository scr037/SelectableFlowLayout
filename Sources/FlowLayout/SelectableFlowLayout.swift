import SwiftUI
import ToggleStyles

public struct SelectableFlowLayout<Content: View>: View {
  // Configuration
  private var isShowSelectionOnTop: Bool
  
  // Content
  @Binding var elements: [String]
  @Binding var selectedElements: [String]
  @ViewBuilder var content: (_ element: String, _ isSelected: Bool) -> Content

  public init(
    elements: Binding<[String]>,
    selectedElements: Binding<[String]>,
    showsSelectionOnTop: Bool,
    @ViewBuilder content: @escaping (String, Bool) -> Content
  ) {
    self._elements = elements
    self._selectedElements = selectedElements
    self.isShowSelectionOnTop = showsSelectionOnTop
    self.content = content
  }

  public var body: some View {
    FlowLayout(items: elements) { element in
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
      .buttonStyle(.plain)
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

struct SelectableFlowLayout_Previews: PreviewProvider {
  @State static var westeros: [String] = [
    "The North",
    "The Iron Islands",
    "The Riverlands",
    "The Vale of Arryn",
    "The Westerlands",
    "The Reach",
    "The Stormlands",
    "The Crownlands"
  ]

  static var selected: [String] = ["The Iron Islands"]

  static var previews: some View {
    ScrollView {
      SelectableFlowLayout(
        elements: $westeros,
        selectedElements: .constant(selected),
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
}

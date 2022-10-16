import SwiftUI
import CombineSchedulers

public struct SelectableHScrollView<Content: View>: View {
  // Configuration
  private var isShowSelectionOnTop: Bool
  private var animation: Animation?
  private var mainQueue: AnySchedulerOf<DispatchQueue>

  // Content
  @Binding private var elements: [String]
  @Binding private var selectedElements: [String]
  @ViewBuilder private var content: (_ element: String, _ isSelected: Bool) -> Content

  public init(
    elements: Binding<[String]>,
    selectedElements: Binding<[String]>,
    showsSelectionOnTop: Bool = true,
    animation: Animation = .easeInOut(duration: 0.5),
    mainQueue: AnySchedulerOf<DispatchQueue>,
    content: @escaping (String, Bool) -> Content
  ) {
    self._elements = elements
    self._selectedElements = selectedElements
    self.isShowSelectionOnTop = showsSelectionOnTop
    self.animation = animation
    self.mainQueue = mainQueue
    self.content = content
  }

  public var body: some View {
    VStack {
      ScrollViewReader { proxy in
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
                    mainQueue.schedule(after: .init(.now() + 0.1)) {
                      proxy.scrollTo(element)
                    }
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
                  .padding(4)
                }
              )
              .animation(animation, value: elements)
              .buttonStyle(.plain)
            }
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
      showsSelectionOnTop: true,
      mainQueue: .immediate
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

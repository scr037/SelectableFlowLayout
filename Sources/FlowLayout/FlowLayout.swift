import SwiftUI

public struct FlowLayout<T: Hashable, Content: View>: View {
  @State private var totalHeight: CGFloat = .zero

  private let items: [T]
  @ViewBuilder private let content: (T) -> Content

  private var animation: Animation
  private var scheduler: DispatchQueue

  public init(
    items: [T],
    animation: Animation = .easeIn(duration: 0.2),
    scheduler: DispatchQueue = DispatchQueue.main,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.items = items
    self.animation = animation
    self.scheduler = scheduler
    self.content = content
  }

  public var body: some View {
    VStack {
      GeometryReader { geometry in
        self.flowContent(in: geometry)
          .animation(animation, value: items)
          .background(withHeight($totalHeight, scheduler: scheduler))
      }
    }
    .frame(height: totalHeight)
  }

  private func flowContent(in geometry: GeometryProxy) -> some View {
    var width = CGFloat.zero
    var height = CGFloat.zero
    return ZStack(alignment: .topLeading) {
      ForEach(self.items, id: \.self) { item in
        self.content(item)
          .padding(4)
          .alignmentGuide(.leading, computeValue: { dimensions in
            if (abs(width - dimensions.width) > geometry.size.width) {
              // End of line
              height -= dimensions.height
              width = 0
            }
            let result = width
            if item == self.items.last {
              // If last item, reset width..
              width = 0
            } else {
              // Calculate new width value.
              width -= dimensions.width
            }
            return result
          })
          .alignmentGuide(.top, computeValue: { _ in
            let result = height
            if item == self.items.last {
              // If last item, reset height.
              height = 0
            }
            return result
          })
        }
      }
  }

  private func withHeight(_ binding: Binding<CGFloat>, scheduler: DispatchQueue) -> some View {
    return GeometryReader { proxy -> Color in
      scheduler.async {
        binding.wrappedValue = proxy.frame(in: .local).size.height
      }
      return .clear
    }
  }
}

struct FlowLayout_Previews: PreviewProvider {
  static var westeros: [String] {
    [
      "The North",
      "The Iron Islands",
      "The Riverlands",
      "The Vale of Arryn",
      "The Westerlands",
      "The Reach",
      "The Stormlands",
      "The Crownlands"
    ]
  }

  static var previews: some View {
    ScrollView {
      FlowLayout(items: westeros, content: { element in
        GroupBox {
          Text(element)
        }
      })
      .padding()
    }
  }
}

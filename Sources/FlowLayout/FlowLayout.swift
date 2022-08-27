import SwiftUI

public struct FlowLayout<T: Hashable, Content: View>: View {
  @State private var totalHeight: CGFloat = .zero

  private let items: [T]
  @ViewBuilder private let content: (T) -> Content

  public init(
    items: [T],
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.items = items
    self.content = content
  }

  public var body: some View {
    VStack {
      GeometryReader { geometry in
        self.flowContent(in: geometry)
          .animation(.easeIn(duration: 0.2), value: items)
          .readHeight($totalHeight, proxy: geometry)
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
          .padding([.horizontal, .vertical], 4)
          .alignmentGuide(.leading, computeValue: { dimensions in
            if (abs(width - dimensions.width) > geometry.size.width) {
              width = 0
              height -= dimensions.height
            }
            let result = width
            if item == self.items.last {
              width = 0
            } else {
              width -= dimensions.width
            }
            return result
          })
          .alignmentGuide(.top, computeValue: { _ in
            let result = height
            if item == self.items.last {
              height = 0
            }
            return result
          })
        }
      }
  }
}

extension View {
  fileprivate func readHeight(_ totalHeight: Binding<CGFloat>, proxy: GeometryProxy) -> some View {
    DispatchQueue.main.async {
      totalHeight.wrappedValue = proxy.frame(in: .local).size.height
    }
    return self
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

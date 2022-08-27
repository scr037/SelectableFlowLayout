# SelectableFlowLayout

*SelectableFlowLayout* displays a collection of _selectable_ SwiftUI items which are arranged in a directional flow, much like lines of text in a paragraph. It relies on a implementations of a basic `FlowLayout`. Any view inside the `SelectableFlowLayout` can be selected or deselected upon user's interaction.

 Both `FlowLayout` and `SelectableFlowLayout` are available for use in this package

##FlowLayout
 
A collection that can arrange custom components using a directional flow according to the available space. It takes an array of `Hashable` elements and a `@ViewBuilder` to provide the a custom component to display for each item in the array.

Example of use:

```swift
var westeros: [String] = [
  "The North",
  "The Iron Islands",
  "The Riverlands",
  "The Vale of Arryn",
  "The Westerlands",
  "The Reach",
  "The Stormlands",
  "The Crownlands"
]

ScrollView {
  FlowLayout(items: westeros, content: { element in
    GroupBox {
      Text(element)
    }
  })
}
```

## SelectableFlowLayout

Relies on the `FlowLayout` and takes in two bound arrays of `String`:
- A `Binding<[String]>` (the *elements*) which represents of all the elements to display in the flow layout.
- A second `Binding<[String]>` of the selected items (the *selected elements*) which is a subset of the first input.

The `@ViewBuilder` should provide for each item in *elements* with a "selectable" representation in form of a SwiftUI component, such as a `Button` or a `Toggle`. Each selected item will be added to the *selected elements* array and it will be removed from it upon deselection. The style of the selected and deselected components depends on the customization done in the `@ViewBuilder`.

In `SelectableFlowLayout`, selected items can be presented on top of collection by setting `showsSelectionOnTop` to `true`. 

Example of use: 
```swift
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

@State static var selected: [String] = ["The Iron Islands"]

ScrollView {
  SelectableFlowLayout(
    elements: $westeros, 
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
```

## Toggle Styles

Ideally, a _selectable_ component can be represented with a SwiftUI `Toggle`. Each Swift `Toggle` view can be customized using `ToggleStyle` protocol. This package offers a `CapsuleToggleStyle` as an example of use.

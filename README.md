# SwiftUIColorPicker

A simple wrapper for UIColorPickerViewController and UIColorWell, making these tools accessible within views and with more customization in SwiftUI. This package was created because there was no way to programmatically bring up the native color picker in SwiftUI, but you can also now insert a UIColorPicker into a VStack or have a free floating UIColorWell button. You can even use the convenient CustomColorPickerButton that will simplify making your own standalone color picking button.

ColorPickerView Usage:
```swift
struct ContentView: View {
    @State var color:Color = .white
    
    var body: some View {
        VStack {
            color.frame(maxHeight:200)
            ColorPickerView(color: $color, showsCloseButton: true)
        }
    }
}
```

ColorPickerButton Usage:
```swift
struct ContentView: View {
    @State var color:Color = .white
    
    var body: some View {
        ZStack {
            color
            ColorPickerButton(color: $color)
        }
    }
}
```

CustomColorPickerButton Usage:
```swift
struct ContentView: View {
    @State var color:Color = .white
    
    var body: some View {
        ZStack {
            color
            CustomColorPickerButton(color: $color) {
                HStack {
                    Spacer()
                    Text("Pick a color")
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.green)
                }
            }
            .padding()
        }
    }
}
```

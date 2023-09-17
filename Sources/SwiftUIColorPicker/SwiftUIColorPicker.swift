//
//  ColorPickerWrapper.swift
//  ScoreBoard
//
//  Created by Kristian Kiraly on 8/22/23.
//

import SwiftUI

public struct ColorPickerView: View {
    @Binding public var color:Color
    @Environment(\.dismiss) private var dismiss
    @State public var showsCloseButton:Bool = false
    
    public init(color: Binding<Color>, showsCloseButton: Bool = false) {
        self._color = color
        self.showsCloseButton = showsCloseButton
    }

    public var body: some View {
        ZStack {
            UIColorPickerViewControllerRepresentable(color: $color)
                .overlay {
                    if showsCloseButton {
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
                }
        }
    }
}

public struct ColorPickerButton: View {
    @Binding public var color:Color
    
    public init(color: Binding<Color>) {
        self._color = color
    }

    public var body: some View {
        CustomColorPickerButton(color: $color) {
            UIColorWellViewRepresentable()
        }
    }
}

public struct CustomColorPickerButton<Content: View>: View {
    @Binding public var color:Color
    @State private var pickingColor:Bool = false
    @ViewBuilder public var label: Content

    public init(color: Binding<Color>, @ViewBuilder content: () -> Content) {
        self._color = color
        self.label = content()
    }

    public var body: some View {
        Button {
            pickingColor = true
        } label: {
            label
        }
        .sheet(isPresented: $pickingColor) {
            ColorPickerView(color: $color, showsCloseButton: true)
        }
    }
}

public struct UIColorWellViewRepresentable: UIViewRepresentable {
    public func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    public func makeUIView(context: Context) -> some UIView {
        let view = UIColorWell()
        view.isUserInteractionEnabled = false
        return view
    }
}

public class UIColorPickerViewModel: NSObject, ObservableObject, UIColorPickerViewControllerDelegate {
    @Binding public var color:Color

    public init(color: Binding<Color>) {
        self._color = color
    }

    public func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.color = Color(uiColor: color)
        }
    }
}

public struct UIColorPickerViewControllerRepresentable: UIViewControllerRepresentable {
    private var model: UIColorPickerViewModel
    @Binding public var color:Color

    public init(color: Binding<Color>) {
        self._color = color
        self.model = UIColorPickerViewModel(color: color)
    }

    public func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let vc = UIColorPickerViewController()
        vc.delegate = model
        vc.selectedColor = UIColor(model.color)
        vc.supportsAlpha = false
        return vc
    }

    public func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        guard !context.transaction.isContinuous else { return }
        uiViewController.delegate = model
        uiViewController.selectedColor = UIColor(model.color)
    }
}

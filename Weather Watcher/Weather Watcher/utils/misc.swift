//
//  utils.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/17/24.
//

import MapKit
import SwiftUI
import Foundation
import UniformTypeIdentifiers
import CoreGraphics
import Combine



enum CustomError: Error {
    case errorMessage(String)
}


extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}


extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension View {
    func getSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.frame(in: .local).size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func applyHorizontalMargin(modifier: Double = 1.0) -> some View {
        self.modifier(ApplyHorizontalMargin(modifier: modifier))
    }
    
    func applyKeyboardPadding(offset: CGFloat = 0) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier(paddingOffset: offset))
    }
}


func formatSecondsToHoursMinutes(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    
    if hours > 1 {
        return "\(hours) hr \(minutes) min"
    } else if minutes > 0 {
        return "\(minutes) min"
    } else {
        return "less than 1 min"
    }
}


struct ApplyHorizontalMargin: ViewModifier {
    let modifier: Double
    let width: Double = (UIScreen.current?.bounds.width ?? 500) * 0.85
    
    func body(content: Content) -> some View {
        content
            .frame(width: width * modifier)
    }
}


struct KeyboardAwareModifier: ViewModifier {
    var paddingOffset: CGFloat
    @State private var keyboardHeight: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height + paddingOffset },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { height in
                withAnimation {
                    self.keyboardHeight = height
                }
            }
    }
}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}


struct UserInputBoder: TextFieldStyle {
    @State private var borderColor: Color = .gray
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(13)
//            .background (
//                RoundedRectangle(cornerRadius: 50)
//                    .stroke(!isFocused ? borderColor : .clear, lineWidth: 1)
//                    .fill(.clear)
//            )
    }
}

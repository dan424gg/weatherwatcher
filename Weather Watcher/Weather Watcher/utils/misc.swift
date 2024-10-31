//
//  utils.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/17/24.
//

import MapKit
import SwiftUI
import Foundation


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


struct UserInputBoder: TextFieldStyle {
    @State var borderColor: Color = .cyan
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(8)
            .background (
                RoundedRectangle(cornerRadius: 30)
                    .stroke(borderColor, lineWidth: 1.5)
                    .fill(.white)
            )
    }
}

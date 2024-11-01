//
//  ContentView.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/15/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

#Preview {
    ContentView()
        .environment(LocationManager())
}

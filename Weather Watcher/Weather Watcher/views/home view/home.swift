//
//  home.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/17/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let home = CLLocationCoordinate2D(latitude: 47.606209, longitude: -122.332069)
}

struct Home: View {
    @State var searchResults: [MKMapItem] = []
    
    
    var body: some View {
        Map {
            Annotation("", coordinate: .home) {
                Image(systemName: "house.fill")
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
        .mapStyle(.standard(showsTraffic: true))
        .safeAreaInset(edge: .bottom) {
            SearchArea(searchResults: $searchResults)
        }
    }
}

#Preview {
    Home()
}

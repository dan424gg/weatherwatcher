//
//  Location Input.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/19/24.
//

import MapKit
import SwiftUI

struct Location_Input: View {
    @Binding var location: String
    @Binding var coordinates: CLLocationCoordinate2D?
    @Binding var visibleRegion: MKCoordinateRegion?
    let textHint: String
    var allowCurrentLocation: Bool = false
    
    @Environment(LocationManager.self) private var locManager
    
    
    func search(for query: String) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .greenlake,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            coordinates = response?.mapItems.first?.placemark.coordinate
        }
    }
    
    
    var body: some View {
        TextField(text: $location, label: {
            if allowCurrentLocation && locManager.userLocation != nil {
                Text("Current Location")
                    .foregroundStyle(.blue)
                    .onAppear {
                        coordinates = locManager.userLocation
                    }
            } else if location.isEmpty {
                Text(textHint)
                    .foregroundStyle(.gray.opacity(0.5))
            } else {
                Text(location)
            }
        })
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .multilineTextAlignment(.center)
        .textFieldStyle(UserInputBoder())
        .onSubmit {
            search(for: location)
        }
        .applyHorizontalMargin()
    }
}

#Preview {
    Location_Input(location: .constant("Where to?"), coordinates: .constant(.greenlake), visibleRegion: .constant(MKCoordinateRegion(
        center: .greenlake,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
), textHint: "Beginning")
        .environment(LocationManager())
}

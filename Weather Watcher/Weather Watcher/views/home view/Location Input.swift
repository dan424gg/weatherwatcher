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
    @Binding var searchResults: [search_result]?
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
            searchResults = response?.mapItems.map { mapItem in
                search_result(coordinates: $coordinates, mapItem: mapItem)
            } ?? []
        }
    }
    
    var textField: some View {
        TextField(text: $location, label: {
            if location.isEmpty && allowCurrentLocation && locManager.userLocation != nil {
                Text("Current Location")
                    .foregroundStyle(.blue)
                    .onAppear {
                        if let userLocation = locManager.userLocation {
                            coordinates = userLocation
                        }
                    }
            } else if location.isEmpty {
                Text(textHint)
                    .foregroundStyle(.gray.opacity(0.5))
            } else {
                Text(location)
            }
        })
        .font(.system(size: 22))
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .multilineTextAlignment(.center)
        .textFieldStyle(UserInputBoder())
        .onChange(of: location) {
            search(for: location)
        }
    }
    
    
    var body: some View {
        textField
            .applyHorizontalMargin()
    }
}

#Preview {
    Location_Input(location: .constant("Where to?"), coordinates: .constant(.greenlake), searchResults: .constant([]), visibleRegion: .constant(MKCoordinateRegion(
                center: .greenlake,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        ), textHint: "Beginning")
                .environment(LocationManager())
}

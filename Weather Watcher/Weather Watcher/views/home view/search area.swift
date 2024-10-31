//
//  search area.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/17/24.
//

import SwiftUI
import MapKit

struct SearchArea: View {
    @Binding var searchResults: [MKMapItem]
    @State var beginning: String = ""
    @State var end: String = ""
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: .home,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    
    
    var body: some View {
        VStack {
            TextField("Beginning", text: $beginning)
                .autocorrectionDisabled()
                .multilineTextAlignment(.center)
                .textFieldStyle(UserInputBoder())
            TextField("End", text: $end)
                .autocorrectionDisabled()
                .multilineTextAlignment(.center)
                .textFieldStyle(UserInputBoder())
            Button("See Weather!") {
                print("looking for weather...")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(width: (UIScreen.current?.bounds.width ?? 500) / 2)
    }
}

#Preview {
    SearchArea(searchResults: .constant([]))
}

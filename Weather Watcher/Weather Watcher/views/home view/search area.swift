//
//  search area.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/17/24.
//

import SwiftUI
import MapKit

struct SearchArea: View {
    @Environment(LocationManager.self) var locManager
    @Binding var position: MapCameraPosition
    
    @Binding var route: MKRoute?
    @Binding var visibleRegion: MKCoordinateRegion?
    @State var beginningText: String = ""
    @State var endText: String = ""
    @State var beginning: CLLocationCoordinate2D?
    @State var end: CLLocationCoordinate2D?
    @State var searchResults: [search_result]?
    @Binding var isInteracting: Bool
    
    @Namespace private var searchArea
    @State private var searchBarSize: CGSize = .zero
    @State private var isFocused: Bool = false
    
    
    enum Focus: Hashable {
        case beginning
        case end
    }
    
    
    func getDirections(from beginning: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: beginning))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            
            route = response?.routes.first
        }
    }
    
    
    var body: some View {
        VStack {
            // search input area
            VStack(spacing: -4) {
                Location_Input(location: $beginningText, coordinates: $beginning, searchResults: $searchResults, visibleRegion: $visibleRegion, textHint: "Where from?", allowCurrentLocation: true)
                    .onTapGesture {
                        withAnimation {
                            isFocused = true
                        }
                    }
                Divider()
                    .applyHorizontalMargin(modifier: 0.6)
                    .frame(height: 2)
                Location_Input(location: $endText, coordinates: $end, searchResults: $searchResults, visibleRegion: $visibleRegion, textHint: "Where to?")
                    .onTapGesture {
                        withAnimation {
                            isFocused = true
                        }
                    }
                    .onChange(of: [beginning, end]) {
                        withAnimation {
                            isFocused = false
                            hideKeyboard()
                            if let beginning, let end {
                                getDirections(from: beginning, to: end)
                            }
                        }
                    }
            }
            .applyHorizontalMargin(modifier: 0.8)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThickMaterial)
                    .stroke(.gray, lineWidth: 1)
            }
            
            // search results area
            if isFocused {
                VStack {
                    if let searchResults {
                        ScrollView {
                            VStack (alignment: .leading, spacing: 15) {
                                ForEach(Array(zip(searchResults.indices, searchResults)), id: \.0) { idx, result in
                                    if idx != 0 {
                                        Divider()
                                            .applyHorizontalMargin()
                                            .frame(height: 2)
                                    }
                                    
                                    result
                                }
                            }
                            .padding(.top)
                        }
                        .clipped()
                        .scrollIndicators(.never)
                    } else {
                        Text("Nothing here!")
                    }
                }
                .animation(.default, value: searchResults)
                .scrollDismissesKeyboard(.immediately)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThickMaterial)
                        .stroke(.gray, lineWidth: 1)
                }
                .transition(.opacity)
                .applyHorizontalMargin()
                .ignoresSafeArea(.keyboard)
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    VStack {
        SearchArea(position: .constant(.automatic), route: .constant(nil), visibleRegion: .constant(MKCoordinateRegion(
            center: .greenlake,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        ), isInteracting: .constant(true))
        .environment(LocationManager())
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(.green)
}

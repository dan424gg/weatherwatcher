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
    @Binding var isInteracting: Bool
    
    @Namespace private var searchArea
    @State private var searchBarSize: CGSize = .zero
    @FocusState private var focusState: Focus?
    
    
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
        if isInteracting {
            VStack {
                Location_Input(location: $beginningText, coordinates: $beginning, visibleRegion: $visibleRegion, textHint: "Where from?", allowCurrentLocation: true)
                    .focused($focusState, equals: .beginning)
                Location_Input(location: $endText, coordinates: $end, visibleRegion: $visibleRegion, textHint: "Where to?")
                    .matchedGeometryEffect(id: "endLocationInput", in: searchArea)
                    .focused($focusState, equals: .end)
                    .onSubmit {
                        withAnimation {
                            isInteracting = false
                            if let beginning, let end {
                                getDirections(from: beginning, to: end)
                            }
                        }
                    }
            }
        } else {
            VStack {
                if !locManager.authStatus {
                    Location_Input(location: $beginningText, coordinates: $beginning, visibleRegion: $visibleRegion, textHint: "Where from?", allowCurrentLocation: true)
                }
                Location_Input(location: $endText,coordinates: $end, visibleRegion: $visibleRegion, textHint: "Where to?")
                    .matchedGeometryEffect(id: "endLocationInput", in: searchArea)
            }
            .disabled(true)
            .onTapGesture {
                withAnimation {
                    isInteracting = true
                    if locManager.authStatus {
                        focusState = .end
                    } else {
                        focusState = .beginning
                    }
                }
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
}

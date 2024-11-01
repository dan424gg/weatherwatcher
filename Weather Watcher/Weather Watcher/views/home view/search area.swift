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
    @State private var searchResults: [MKMapItem] = []
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
//        if isInteracting {
        VStack {
            VStack(spacing: -4) {
                    Location_Input(location: $beginningText, coordinates: $beginning, visibleRegion: $visibleRegion, textHint: "Where from?", allowCurrentLocation: true)
                    .onTapGesture {
                        withAnimation {
                            isFocused = true
                        }
                    }
                    Divider()
                        .applyHorizontalMargin(modifier: 0.6)
                        .frame(height: 2)
                    Location_Input(location: $endText, coordinates: $end, visibleRegion: $visibleRegion, textHint: "Where to?")
                        .matchedGeometryEffect(id: "endLocationInput", in: searchArea)
                        .onTapGesture {
                            withAnimation {
                                isFocused = true
                            }
                        }
                        .onSubmit {
                            withAnimation {
                                isFocused = false
                                if let beginning, let end {
                                    getDirections(from: beginning, to: end)
                                }
                            }
                        }
                }
                .applyHorizontalMargin(modifier: 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThickMaterial)
                        .stroke(.gray, lineWidth: 1)
                }
            
            if isFocused {
                ScrollView {
                    VStack (spacing: 15) {
                        search_result(mapItem: {
                            let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
                            let placemark = MKPlacemark(coordinate: coordinate)
                            var item = MKMapItem(placemark: placemark)
                            item.name = "Starbucks"
                            item.pointOfInterestCategory = .cafe
                            
                            return item
                        }(), route: MKRoute())
                        Divider()
                        search_result(mapItem: {
                            let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
                            let placemark = MKPlacemark(coordinate: coordinate)
                            var item = MKMapItem(placemark: placemark)
                            item.name = "Starbucks"
                            item.pointOfInterestCategory = .cafe
                            
                            return item
                        }(), route: MKRoute())
                        Divider()
                        search_result(mapItem: {
                            let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
                            let placemark = MKPlacemark(coordinate: coordinate)
                            var item = MKMapItem(placemark: placemark)
                            item.name = "Starbucks"
                            item.pointOfInterestCategory = .cafe
                            
                            return item
                        }(), route: MKRoute())
                        Divider()
                        search_result(mapItem: {
                            let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
                            let placemark = MKPlacemark(coordinate: coordinate)
                            var item = MKMapItem(placemark: placemark)
                            item.name = "Starbucks"
                            item.pointOfInterestCategory = .cafe
                            
                            return item
                        }(), route: MKRoute())
                        Divider()
                        search_result(mapItem: {
                            let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
                            let placemark = MKPlacemark(coordinate: coordinate)
                            var item = MKMapItem(placemark: placemark)
                            item.name = "Starbucks"
                            item.pointOfInterestCategory = .cafe
                            
                            return item
                        }(), route: MKRoute())
                    }
                    .padding(.top)
                }
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThickMaterial)
                        .stroke(.gray, lineWidth: 1)
                }
                .transition(.opacity)
                .applyHorizontalMargin()
                .frame(maxHeight: .infinity)
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
    .background(.green)
}

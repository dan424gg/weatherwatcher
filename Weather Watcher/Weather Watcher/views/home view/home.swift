//
//  home.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/17/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let greenlake = CLLocationCoordinate2D(latitude: 47.6797, longitude: 122.3256)
}



struct Home: View {
    @Environment(LocationManager.self) var locManager
    @State private var visibleRegion: MKCoordinateRegion?
    @State var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
//    @State var searchResults: [MKMapItem] = []
    @State var route: MKRoute?
    @State var isSearching: Bool = false
    @Namespace private var mapScope

    
    var body: some View {
        Map(position: $position, scope: mapScope) {
            if let route {
                Annotation("", coordinate: route.steps.first!.polyline.coordinate) {
                    Image(systemName: "figure.wave")
                        .padding(4)
                        .font(.system(size: 25))
                        .foregroundStyle(.white)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
                Marker("Destination", coordinate: route.steps.last!.polyline.coordinate)
            }
            
            Marker(item: {
                let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
                let placemark = MKPlacemark(coordinate: coordinate)
                var item = MKMapItem(placemark: placemark)
                item.name = "Apple Park"
                
                return item
            }())

            
            UserAnnotation()
        }
        .mapControls {}
        .overlay(alignment: .bottomTrailing) {
            VStack {
                MapCompass()
                    .mapControlVisibility(.automatic)
                MapUserLocationButton(scope: mapScope)
            }
            .padding(.trailing, 10)
            .buttonBorderShape(.circle)
        }
        .mapScope(mapScope)
        .blur(radius: isSearching ? 10 : 0)
        .onChange(of: route) {
            position = .automatic
        }
        .onMapCameraChange {
            visibleRegion = $0.region
        }
        .overlay(alignment: .top) {
            SearchArea(position: $position, route: $route, visibleRegion: $visibleRegion, isInteracting: $isSearching)
        }
    }
}

#Preview {
    Home()
        .environment(LocationManager())
}

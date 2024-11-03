//
//  search result.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/26/24.
//

import MapKit
import SwiftUI

struct search_result: View, Equatable {
    static func == (lhs: search_result, rhs: search_result) -> Bool {
        return lhs.mapItem == rhs.mapItem
    }
    
    @Binding var coordinates: CLLocationCoordinate2D?
    let mapItem: MKMapItem
    var route: MKRoute? = nil
    
    
    private func convertToUserMeasurement(_ distance: Double) -> String {
        // TODO convert to Kilometers too
        let convertedValue = distance / 1609.344
        
        if convertedValue < 100 {
            return String(format: "%.1f miles", convertedValue)
        } else {
            return "\(Int(convertedValue)) miles"
        }
    }
    
    private func symbolForCategory(_ category: MKPointOfInterestCategory?) -> String {
        switch category {
        case .airport:
            return "airplane"
        case .atm:
            return "banknote"
        case .bakery:
            return "cupcake"
        case .cafe:
            return "cup.and.saucer"
        case .hospital:
            return "cross.case"
        case .library:
            return "books.vertical"
        case .museum:
            return "building.columns"
        case .park:
            return "leaf"
        case .restaurant:
            return "fork.knife"
        case .school:
            return "graduationcap"
        case .stadium:
            return "sportscourt"
        case .zoo:
            return "tortoise"
        default:
            return "mappin" // Default symbol if no category matches
        }
    }

    
    var body: some View {
        HStack {
            Image(systemName: symbolForCategory(mapItem.pointOfInterestCategory))
                .font(.system(size: 25))
            VStack(alignment: .leading) {
                Text(mapItem.name ?? "Loading...")
                    .truncationMode(.tail)
                HStack {
                    Text("0hr 0min")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                    Divider()
                    Text("0 miles")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
//                    Text(formatSecondsToHoursMinutes(Int(route.expectedTravelTime.magnitude)))
//                        .foregroundStyle(.gray)
//                        .font(.system(size: 14))
//                    Divider()         
//                    Text(convertToUserMeasurement(route.distance.magnitude))
//                        .foregroundStyle(.gray)
//                        .font(.system(size: 14))
                }
            }
        }
        .onTapGesture {
            // when this singular result is tapped, we give the coordinate of this result to the corresponding coordinate state in Location Input
            withAnimation {
                coordinates = mapItem.placemark.coordinate
            }
        }
        .applyHorizontalMargin()
    }
}

#Preview {
    search_result(coordinates: .constant(.greenlake), mapItem: {
        let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
        let placemark = MKPlacemark(coordinate: coordinate)
        var item = MKMapItem(placemark: placemark)
        item.name = "Starbucks"
        item.pointOfInterestCategory = .cafe
        
        return item
    }(), route: MKRoute())
}

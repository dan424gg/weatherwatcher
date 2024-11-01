//
//  search result.swift
//  Weather Watcher
//
//  Created by Daniel Wells on 10/26/24.
//

import MapKit
import SwiftUI

struct search_result: View {
    let mapItem: MKMapItem
    let route: MKRoute
    
    private func convertToUserMeasurement(_ distance: Double) -> String {
        // TODO convert to Kilometers too
        var convertedValue = distance / 1609.344
        
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
                HStack {
                    Text(formatSecondsToHoursMinutes(Int(route.expectedTravelTime.magnitude)))
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                    Divider()         
                    Text(convertToUserMeasurement(route.distance.magnitude))
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                }
            }
        }
        .applyHorizontalMargin()
    }
}

#Preview {
    search_result(mapItem: {
        let coordinate = CLLocationCoordinate2D(latitude: 37.334722, longitude: -122.008889) // Apple Park
        let placemark = MKPlacemark(coordinate: coordinate)
        var item = MKMapItem(placemark: placemark)
        item.name = "Starbucks"
        item.pointOfInterestCategory = .cafe
        
        return item
    }(), route: MKRoute())
}

import SwiftUI
import CoreLocation
import MapKit

@Observable class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D?
    var authStatus: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // This delegate method is called when location updates are received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Update the user's location on the main thread
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }
    
    // Handle changes in authorization status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            authStatus = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            authStatus = false
            print("Location access denied or restricted.")
        case .notDetermined:
            authStatus = false
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

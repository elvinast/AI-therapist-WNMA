//
//  MapManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/6/23.
//

import Foundation
import MapKit
import CoreLocation

class MapManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.80341200169129,
            longitude:  -122.40623140737449),
        span: MKCoordinateSpan(
            latitudeDelta: 0.04,
            longitudeDelta: 0.04))
    
    // Filter Bubbles
    @Published var focusedFilter: Int = 0
    // Filters = [Therapists (0), Primary Care (1), Pyschology (2), Fitness (3), Rehabilitation (4)]
    
    @Published var isDetailedPopupShowing: Bool = false
    @Published var focusedDoctor: Int = 0
    
    
    var locationManager = CLLocationManager()
    
    var locations = [
        Location(name: "Ferry Building", coordinate: CLLocationCoordinate2D(latitude: 37.796154530569595, longitude: -122.3923854711943)),
        Location(name: "Coit Tower", coordinate: CLLocationCoordinate2D(latitude: 37.80381187785741, longitude: -122.44520093694825)),
        Location(name: "Tenderloin", coordinate: CLLocationCoordinate2D(latitude: 37.786, longitude: -122.41520093694825)),
        Location(name: "Sum", coordinate: CLLocationCoordinate2D(latitude: 37.80081187785741, longitude: -122.41520093694825))
    ]
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: // Location services are available
            authorizationStatus = .authorizedWhenInUse
            manager.requestLocation()
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: manager.location?.coordinate.latitude ?? 0, longitude: manager.location?.coordinate.longitude ?? 0),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.03, longitudeDelta: 0.03)
            )
            break
        case .restricted, .denied: // Location services are unavailable
            authorizationStatus = .restricted
            break
        case .notDetermined: // Auth not determined yet
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
}


struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

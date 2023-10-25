//
//  LocationWorker.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import CoreLocation
import Combine

class LocationWorker: NSObject, ObservableObject {
    
    private let locationManager: CLLocationManager = {
        let location = CLLocationManager()
        location.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        return location
    }()
    let locationPublisher = PassthroughSubject<CLLocation, Never>()
    
    @Published var location: CLLocation?
    
    private func requestGeoAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func requestGeoSwitcher() {
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            requestGeoAccess()
            getGeo()
        case .restricted:
            requestGeoAccess()
            getGeo()
        case .denied:
            requestGeoAccess()
            getGeo()
        case .authorizedAlways:
            getGeo()
        case .authorizedWhenInUse:
            getGeo()
        @unknown default:
            requestGeoAccess()
        }
    }
    
    func getGeo() {
       
        locationManager.startUpdatingLocation()
    }
    
    func fetchGeo(from city: City?) {
        if city != nil {
            guard let coord = city?.coord, let lat = coord.lat, let lon = coord.lon else { return }
            var coords = CLLocation(latitude: lat, longitude: lon)
            self.location = coords
        } else {
            requestGeoSwitcher()
        }
       
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationWorker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            self.location = location
//            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestGeoSwitcher()
    }
}

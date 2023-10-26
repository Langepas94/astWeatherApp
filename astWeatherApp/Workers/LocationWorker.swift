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
    let locationPublisher = PassthroughSubject<(lat: Double, lon: Double), Never>()
    
    var location = (lat: 0.0, lon: 0.0)
    private func requestGeoAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestGeoSwitcher() {
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
    
    
//    func fetchGeo(from city: City?) {
//      
//        if city != nil {
//            guard let coord = city?.coord, let lat = coord.lat, let lon = coord.lon else { return }
//            let coords = CLLocation(latitude: lat, longitude: lon)
//            self.location = coords
//        } else {
//            requestGeoSwitcher()
//        }
//    }
    
}

extension LocationWorker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = (lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            locationPublisher.send((location.coordinate.latitude, location.coordinate.longitude))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestGeoSwitcher()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

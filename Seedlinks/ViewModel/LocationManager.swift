//
//  LocationManager.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 17/02/22.
//

import CoreLocation
import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    
    //Default position = San Giovanni a Teduccio
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.836501, longitude: 14.306021),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.05))
    
    // Reverse geolocation
    @Published var streetName : String = ""
    @Published var cityName : String = "Searching for current location"
    let geoCoder = CLGeocoder()
    
    func reverseGeo(latitude : Double, longitude : Double ) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
                                            {
            placemarks, error -> Void in
            
            // Place details
            guard let placeMark = placemarks?.first else { return }
            
            // Location name
            if let locationName = placeMark.location {
                print(locationName)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                self.streetName = street
                print(street)
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                self.cityName = city
                print(city)
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            // Country
            if let country = placeMark.country {
                print(country)
            }
        })
    }
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString : String {
        
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authInUse"
        case .authorizedAlways: return "authAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func getRegion() {
        if let location = self.lastLocation {
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        }
    }
    
    func setRegion(latitude : Double, longitude : Double){
       
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        self.getRegion()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        // print(#function, location)
    }
}


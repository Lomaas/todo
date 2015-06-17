//
//  LocationManager.swift
//  Todo
//
//  Created by Simen Johannessen on 24/05/15.
//  Copyright (c) 2015 lomas. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationManagerProtocol {
    func locationManager(didUpdateLocation location: Location)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var delegate: LocationManagerProtocol?
    
    func startUpdatingLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.delegate = nil
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        var bgIdentifier: UIBackgroundTaskIdentifier!

        bgIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(bgIdentifier)
        })
        print("Location updated")
        
        let location = locations.last as! CLLocation
        let loc = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        delegate?.locationManager(didUpdateLocation: loc)
        
        if let todos = Todos.todosCloseBy(location) {
            NotificationService.showNotifications(todos)
        }

    }
}
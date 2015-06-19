import Foundation
import CoreLocation
import UIKit

protocol LocationManagerProtocol {
    func locationManager(didUpdateLocation location: Location)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    var delegate: LocationManagerProtocol?
    
    func startUpdatingLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
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
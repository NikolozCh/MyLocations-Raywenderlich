//
//  ViewController.swift
//  MyLocations
//
//  Created by Nikoloz Chitashvili on 05.06.22.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLabels()
    }
    
    
    // MARK: - Actions
    @IBAction func getLocation() {
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        else if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
        updateLabels()
    }
    // MARK: - Helper methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Locations Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        }
        else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
    }
}


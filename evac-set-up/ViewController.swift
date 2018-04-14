//
//  ViewController.swift
//  evac-set-up
//
//  Created by Ruochun Wang on 4/14/18.
//  Copyright © 2018 Ruochun Wang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
  
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("location status changed")
            locationManager.startUpdatingLocation()
        }
        else if status == .denied {
            print("Authorization is not available")
        }
        else {
            print("status unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        var loc=locations[0]
        latitude.text="\(loc.coordinate.latitude)"
        longitude.text="\(loc.coordinate.longitude)"
        print(loc.coordinate.latitude)
        print(loc.coordinate.longitude)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}


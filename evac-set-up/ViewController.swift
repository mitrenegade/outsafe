//
//  ViewController.swift
//  evac-set-up
//
//  Created by Ruochun Wang on 4/14/18.
//  Copyright © 2018 Ruochun Wang. All rights reserved.
//

import UIKit
import CoreLocation

enum ExitType:String{
    case saferoom
    case door
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var exit: UIButton!
    @IBOutlet weak var corner: UIButton!
    @IBOutlet weak var saferoom: UIButton!
    @IBOutlet weak var landmark: UIButton!
    @IBOutlet weak var id: UITextField!
    
    
    
    
    @IBAction func clickedButton(_ sender: UIButton) {
        guard let latitudeString = latitude.text as? NSString else { return }
        guard let longitudeString = longitude.text as? NSString else { return }
        
        var params: [String: Any] = ["lat": latitudeString.doubleValue,
                                     "lon": longitudeString.doubleValue,
                                     "el": 0]
        switch sender{
        case exit:
            params["type"] = ExitType.door.rawValue
            sendData(params: params, name: "exit")
        
        case corner:
            params["label"] = "corner"
            sendData(params: params, name: "landmark")
            
        case saferoom:
            params["type"] = ExitType.saferoom.rawValue
            sendData(params: params, name: "exit")
            
        
        default: return

        }
        
    }
    
     @IBAction func clickedLandmark(_ sender: UIButton) {
        
        guard let latitudeString = latitude.text as? NSString else { return }
        guard let longitudeString = longitude.text as? NSString else { return }
        
        let alert = UIAlertController(title: "Great Title", message: "Please input something", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Name Input", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            print(textField.text)
            var params: [String: Any] = ["lat": latitudeString.doubleValue,
                                         "lon": longitudeString.doubleValue,
                                         "el": 0]
            if let nameString = textField.text{
                params["label"] = nameString
            }
            self.sendData(params: params, name: "Landmark")

            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your name"
        }
        
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
    }
    
    
    func sendData(params:[String:Any], name: String){
    
        let service = APIService()
        guard let idString = id.text else {return}
       
        service.cloudFunction(id: idString, functionName: name, params: params) { (result, error) in
            print(result)
            print(error)
        }
    }
    
   
    
    
  
    
    
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


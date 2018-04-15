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
        
        let latValue = latitudeString.doubleValue
        let lonValue = longitudeString.doubleValue
        
        
        var params: [String: Any] = ["lat": latValue,
                                     "lon": lonValue,
                                     "el": 0]
        switch sender{
        case exit:
            params["type"] = ExitType.door.rawValue
            sendData(params: params, name: "exit")
            //feedback(place: "Exit", lat: latValue, lon: lonValue)
        
        case corner:
            params["label"] = "corner"
            sendData(params: params, name: "landmark")
            //feedback(place: "Corner", lat: latValue, lon: lonValue)
            
            
        case saferoom:
            params["type"] = ExitType.saferoom.rawValue
            sendData(params: params, name: "exit")
            //feedback(place: "Saferoom", lat: latValue, lon: lonValue)
            
        
        default: return

        }
        
    }
    
     @IBAction func clickedLandmark(_ sender: UIButton) {
        
        guard let latitudeString = latitude.text as? NSString else { return }
        guard let longitudeString = longitude.text as? NSString else { return }
        
        let latValue = latitudeString.doubleValue
        let lonValue = longitudeString.doubleValue
        
        let alert = UIAlertController(title: "Please label the landmark:", message: "ex: stage, screen, restroom...", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            print(textField.text)
            var params: [String: Any] = ["lat": latValue,
                                         "lon": lonValue,
                                         "el": 0]
            if let nameString = textField.text{
                params["label"] = nameString
            }
            self.sendData(params: params, name: "Landmark")
            //self.feedback(place: "Landmark", lat: latValue, lon: lonValue)

            
        }
        
        let action = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = " "
        }
        
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
    }
    
    
    func sendData(params:[String:Any], name: String){
    
        let service = APIService()
        guard let idString = id.text else {return}
       
        service.cloudFunction(id: idString, functionName: name, params: params) { (result, error) in
            DispatchQueue.main.async {
                if let successfulResult = result as? [String:Any]{
                    print(result)
                    let title = "Saved!"
                    let lon = successfulResult["lon"]!
                    let lat = successfulResult["lat"]!
                    if let placeLabel = successfulResult["label"]{
                        let message = "\(placeLabel): \n\(lat),\n\(lon)"
                        self.feedback(title: title, message: message)
        
                    }else{
                        if let placeType = successfulResult["type"]{
                            let message = "\(placeType): \n\(lat),\n\(lon)"
                            self.feedback(title: title, message: message)
                        }
                   
                    }
                    
                    
                    
                }
                else{
                    if let failedResult = error{
                        let title = "Error!"
                        let message = "Please try again"
                        print(failedResult)
                        self.feedback(title: title, message: message)
                    }
                }
            }
        }
    }
    
    
    func feedback(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated:true, completion: nil)
        
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
        
        let keyboardNextButtonView = UIToolbar()
        keyboardNextButtonView.sizeToFit()
        keyboardNextButtonView.barStyle = UIBarStyle.black
        keyboardNextButtonView.isTranslucent = true
        keyboardNextButtonView.tintColor = UIColor.white
        let button: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelInput))
        let flex: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        keyboardNextButtonView.setItems([flex, button], animated: true)
        
        id.inputAccessoryView = keyboardNextButtonView

    }
    
    @objc func cancelInput() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}


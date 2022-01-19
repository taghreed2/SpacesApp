//
//  NewSpaceVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.

//fix....

import UIKit
import Firebase
import CoreLocation

class NewSpaceVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var price: UITextField!
    
    var latitude:Double?
    var longitude:Double?
    var HostName = String()
    var HostNum = String()
    let db = Firestore.firestore()
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readHostDocsDsta()
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        hideKeyboard(view: view)
        roundCorners(view: subview)
        
    }
    
    // MARK: IBActions
    
    @IBAction func addSpace(_ sender: Any) {
        
        addNewSpaceData()
        
    }
   
    // MARK: Functons
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("latitude = \(locValue.latitude) "," longitude = \(locValue.longitude)")
        latitude = locValue.latitude
        longitude = locValue.longitude
        
    }
    
    func addNewSpaceData() {
        
        db.collection("Host").document("\(Auth.auth().currentUser!.uid)").collection("NewSpace").document("CLLocationCoordinate2D(latitude: \(latitude!), longitude: \(longitude!))").setData(
            [
                "desc": desc.text,
                "duration": duration.text,
                "price": price.text,
                "latitude": latitude,
                "longitude":longitude,
                "HostName":HostName,
                "HostNum":HostNum,
                "HostID": Auth.auth().currentUser?.uid
            ]
        )
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func readHostDocsDsta(){
        
        let docRef = db.collection("Host").document("\(Auth.auth().currentUser!.uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.HostName = document.get("name") as! String
                self.HostNum = document.get("phoneNumber") as! String
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    

    
}

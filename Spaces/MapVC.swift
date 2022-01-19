//
//  MapVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
import MapKit

// move to model....
struct Coor {
    let latitude:Double?
    let longitude:Double?
    
}
//....


class MapVC: UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var Cmap: MKMapView!
    var coorArr = [Coor]()
    var latitude:Double?
    var longitude:Double?
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Cmap.delegate = self
        
        readSubcollectionDocs()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func readSubcollectionDocs(){
        db.collection("Host").getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    print("doc:\(doc.documentID)")
                    self.db.collection("Host").document("\(doc.documentID)").collection("NewSpace").getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                self.latitude = document.get("latitude") as? Double
                                self.longitude = document.get("longitude") as? Double
                                self.coorArr.append(Coor(latitude: self.latitude, longitude: self.longitude))
                             }
                            self.markers()
                        }
                    }
                }
            }
        }
   }
    
    
    func markers(){
        print("in markers func " , coorArr.count)
        for i in coorArr {
            let  lat = i.latitude
            let long = i.longitude
            let anno = MKPointAnnotation()
            anno.coordinate = CLLocationCoordinate2D(latitude: lat! , longitude: long!)
            Cmap.addAnnotation(anno)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRequestVCid") as! NewRequestVC
        vc.modalPresentationStyle = .fullScreen
        if let annotationcoordinate = view.annotation?.coordinate
        {
            // annotationcoordinate change it from CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.1337) to lat and long
            vc.coordinate = "\(annotationcoordinate)"
            print("\(annotationcoordinate)")
            print(vc.coordinate!)
        }
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



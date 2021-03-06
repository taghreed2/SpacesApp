//
//  StartVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
class StartVC: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var cutomerButton: UIButton!
    @IBOutlet weak var hostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if Auth.auth().currentUser?.uid != nil {
            check()
        }
    }
    
    
    
    //MARK: Functions
    
    func check(){
        
        let customerRef = db.collection("Customer").document("\(Auth.auth().currentUser!.uid)")
        customerRef.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                   // print("Document data: \(document.data())")
                    self.performSegue(withIdentifier: "customerseg", sender: nil)
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        let hostRef = db.collection("Host").document("\(Auth.auth().currentUser!.uid)")
        hostRef.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                
                    self.performSegue(withIdentifier: "hostseg", sender: nil)
                } else {
                    print("Document does not exist")
                }
            }
        }
        
    }
    
   
    
    
}

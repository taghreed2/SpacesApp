//
//  NewRequestVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
class NewRequestVC: UIViewController {
    
    @IBOutlet weak var hostInfoView: UIView!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var hostNum: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var customerList: UITextView!
    
    let db = Firestore.firestore()
    var coordinate : String?
    var customerName : String?
    var customerNum : String?
    var HostID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readHostInfo()
        readCustomerInfo()
        hideKeyboard(view: view)
        roundCorners2(view: hostInfoView)
        
    }
    
   //MARK: @IBAction
    
    @IBAction func newRec(_ sender: Any) {
        addNewRequestData()
    }
    
    //MARK: @IBAction

    func readHostInfo(){
        
        db.collection("Host").getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    
                    self.db.collection("Host").document("\(doc.documentID)").collection("NewSpace").document(self.coordinate!).getDocument { documentSnapshot , err in
                        if let doc = documentSnapshot , doc.exists {
                        
                            self.hostName.text = doc.get("HostName") as? String ?? "no HostName"
                            self.desc.text = doc.get("desc") as? String ?? "no desc"
                            self.price.text = doc.get("price") as? String ?? "no price"
                            self.duration.text = doc.get("duration") as? String ?? "no duration"
                            self.hostNum.text = doc.get("HostNum") as? String ?? "no HostNum"
                            self.HostID =  doc.get("HostID") as? String ?? "no HostID"
                            
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
    func addNewRequestData() {
        
       db.collection("Customer").document("\(Auth.auth().currentUser!.uid)").collection("NewRequest").document("\(HostID!)").setData(
            [
            "customerName":customerName,
            "customerNum":customerNum,
            "customerID":Auth.auth().currentUser!.uid,
            "customerList": customerList.text,
            "state":"انتظار",
            "HostID" : HostID,
            "HostName" : hostName.text,
            "hostNum" : hostNum.text,
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
    
   func readCustomerInfo(){
       
        let docRef = db.collection("Customer").document("\(Auth.auth().currentUser!.uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.customerName = document.get("name") as! String
                self.customerNum = document.get("phoneNumber") as! String
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    

}

//
//  HostProfileVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
let db = Firestore.firestore()

class HostProfileVC: UIViewController {
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tv: UITableView!
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    var RentedSpaceArr = [RentedSpace]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        HostInfo()
        RentedSpacesInfo()
        tv.addSubview(refreshControl)
        roundCorners2(view: tv)
        roundCorners2(view: subview)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        RentedSpaceArr.removeAll()
        RentedSpacesInfo()
        refreshControl.endRefreshing()
        
    }
    
    
    
    
    //MARK:  @IBAction
    
    @IBAction func signOut(_ sender: Any) {
        
        signout()
        
    }
    
    
    //MARK: Functions
    
    func HostInfo() {
        
        let docRef = db.collection("Host").document("\(Auth.auth().currentUser!.uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.name.text = document.get("name") as! String
                self.phoneNum.text = document.get("phoneNumber") as! String
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func signout(){
        
        do{
            try  Auth.auth().signOut()
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVCid") as!LoginVC
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        }catch{
            print("error")
        }
    }
    
    func RentedSpacesInfo(){
        
        db.collection("Customer").getDocuments()
        
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for doc in querySnapshot!.documents {
                    db.collection("Customer").document("\(doc.documentID)").collection("NewRequest").document("\(Auth.auth().currentUser!.uid)").getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
                            if document.get("state") as! String == "تم القبول" {
                                
                                self.RentedSpaceArr.append(RentedSpace(customerName: document.get("customerName") as! String, customerNum: document.get("customerNum") as! String, state: document.get("state") as! String))
                                
                            }
                           
                            self.tv.reloadData()
                            
                        } else {
                            print("Document does not exist")
                        }
                    })
                }
            }
        }
    }
}



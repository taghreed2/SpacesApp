//
//  CustomerProfileVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
import SwiftUI

class CustomerProfileVC: UIViewController  {
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var cusName: UILabel!
    @IBOutlet weak var cusNum: UILabel!
    @IBOutlet weak var tv: UITableView!
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    var customerRequestsArr = [CustomerRequest]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        customerInfo()
        print("in viewdid:",customerRequestsArr.count)
        readNewRequestData()
        tv.addSubview(refreshControl)
        roundCorners2(view: tv)
        roundCorners2(view: subview)
        
    }
    
    //MARK: @IBAction
    
    @IBAction func logout(_ sender: Any) {
        
        signout()
        
    }
    
    //MARK: Functions
    
    @objc func refresh(_ sender: AnyObject) {
        
        customerRequestsArr.removeAll()
        readNewRequestData()
        refreshControl.endRefreshing()
        
    }
    
    
    func signout(){
        do{
            try  Auth.auth().signOut()
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVCid") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        }catch{
            print("error")
        }
    }
    
    func customerInfo() {
        let docRef = db.collection("Customer").document("\(Auth.auth().currentUser!.uid)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.cusName.text = document.get("name") as? String ?? "no name "
                self.cusNum.text = document.get("phoneNumber") as? String ?? "no phoneNumber"
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func readNewRequestData(){
        
        self.db.collection("Customer").document("\(Auth.auth().currentUser!.uid)").collection("NewRequest").getDocuments { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    
                    self.customerRequestsArr.append(CustomerRequest(hostName: doc.get("HostName")as? String ?? "no HostName", hostNum: doc.get("hostNum") as? String ?? "no hostNum", state: doc.get("state") as? String ?? "no state", HostID: doc.get("HostID") as? String ?? "no HostID"))}
                self.tv.reloadData()
            }
            print("in func:",self.customerRequestsArr.count)
            
            
        }
    }

    

    
}



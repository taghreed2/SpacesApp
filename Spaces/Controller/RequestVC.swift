//
//  RequestVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase



class RequestVC: UIViewController {
    
    @IBOutlet weak var tv: UITableView!
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    let db = Firestore.firestore()
    var HostRequestArr = [HostRequest]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        readSubcollectionDocs()
        tv.addSubview(refreshControl)
        
    }
    
    //MARK: Functions
    @objc func refresh(_ sender: AnyObject) {
        HostRequestArr.removeAll()
        readSubcollectionDocs()
        refreshControl.endRefreshing()
      }
    
    
    
    func readSubcollectionDocs(){
        db.collection("Customer").getDocuments(){ [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    print("dooocc\(doc.documentID)")
                    self.db.collection("Customer").document("\(doc.documentID)").collection("NewRequest").getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for doc in querySnapshot!.documents {
                                if (doc.get("HostID")as? String ?? "nil") == Auth.auth().currentUser?.uid && doc.get("state") as! String != "تم القبول" &&  doc.get("state") as! String != "تم الرفض" {
                                    self.HostRequestArr.append(HostRequest(customerName: doc.get("customerName") as? String ?? "no customerName", customerNum: doc.get("customerNum") as? String ?? "customerNum", customerID: doc.get("customerID") as? String ?? "no customerName" ))
                                    self.tv.reloadData()
                            }
                        }
                    }
                }
                
            }
            
        }
        
    }
 }

    
 
    
}


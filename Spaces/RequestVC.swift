//
//  RequestVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase

// move ...
struct HostRequest {
    let customerName: String
    let customerNum: String
    let customerID : String
    
}
//...


class RequestVC: UIViewController {
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
   
    
    
    
    let db = Firestore.firestore()
    var HostRequestArr = [HostRequest]()
    
    @IBOutlet weak var tv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readSubcollectionDocs()
        tv.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        HostRequestArr.removeAll()
        readSubcollectionDocs()
        refreshControl.endRefreshing()
      }
    
    
    
    func readSubcollectionDocs(){
        db.collection("Customer").getDocuments()
        
        { (querySnapshot, err) in
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
                                    self.HostRequestArr.append(HostRequest(customerName: doc.get("customerName") as! String ?? "no customerName", customerNum: doc.get("customerNum") as! String ?? "customerNum", customerID: doc.get("customerID") as! String ?? "no customerName" ))
                                    self.tv.reloadData()
                            }
                        }
                    }
                }
                
            }
            
        }
        
    }
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
extension RequestVC : UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HostRequestArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HostRequestCell
        cell.customerName.text = HostRequestArr[indexPath.row].customerName
        cell.customerNum.text = HostRequestArr[indexPath.row].customerNum
        cell.customerID = HostRequestArr[indexPath.row].customerID
       
        return cell
    }
    
    
}

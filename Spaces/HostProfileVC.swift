//
//  HostProfileVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
let db = Firestore.firestore()
// move ...
struct RentedSpace {
    let customerName : String
    let customerNum : String
    let state : String
    
}



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
        print(Auth.auth().currentUser!.uid)
        HostInfo()
        RentedSpacesInfo()
        tv.addSubview(refreshControl)
        roundCorners2(view: tv)
        roundCorners2(view: subview)
       

        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(_ sender: AnyObject) {
        RentedSpaceArr.removeAll()
        RentedSpacesInfo()
        refreshControl.endRefreshing()
      }
    
    
   
    
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
    
    
    @IBAction func signOut(_ sender: Any) {
        signout()
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
                           
                            print(self.RentedSpaceArr.count)
                            self.tv.reloadData()
                        } else {
                            print("Document does not exist")
                        }
                    })
                    
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

extension HostProfileVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RentedSpaceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RentedSpacesCell
        cell.customerName.text = RentedSpaceArr[indexPath.row].customerName
        cell.customerNum.text = RentedSpaceArr[indexPath.row].customerNum
        cell.state.text = RentedSpaceArr[indexPath.row].state

        return cell
    }
    
    
    
    
}

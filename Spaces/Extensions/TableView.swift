//
//  TableView.swift
//  Spaces
//
//  Created by TAGHREED on 16/06/1443 AH.
//

import Foundation
import UIKit
import Firebase

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

extension CustomerProfileVC : UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerRequestsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerRequestCell
        cell.hostName.text = customerRequestsArr[indexPath.row].hostName
        cell.hostNum.text = customerRequestsArr[indexPath.row].hostNum
        cell.state.text = customerRequestsArr[indexPath.row].state
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        for  customerRequest in customerRequestsArr {
            
            if customerRequest.state != "تم القبول" {
                
                if editingStyle == .delete {
                    
                    customerRequestsArr.remove(at: indexPath.row)
                    tv.deleteRows(at: [indexPath], with: .automatic)
                    db.collection("Customer").document("\(Auth.auth().currentUser!.uid)").collection("NewRequest").document(customerRequest.HostID).delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            
            }else{
                print("you cant delet")
                // alert
            }
        }
    }
}




//
//  HostRequestCell.swift
//  Spaces
//
//  Created by TAGHREED on 11/06/1443 AH.
//
//fix ...

import UIKit
import Firebase
class HostRequestCell: UITableViewCell {
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerNum: UILabel!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var accBtn: UIButton!
    var customerID : String!
    let db = Firestore.firestore()

    
    @IBAction func accAction(_ sender: Any) {
        
        declineBtn.isEnabled = false
        
        db.collection("Customer").document(customerID).collection("NewRequest").document(Auth.auth().currentUser!.uid).updateData([
                "state" : "تم القبول"
            ])

        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        // then delet the cell ....
        
    }
    @IBAction func deAction(_ sender: Any) {
        accBtn.isEnabled = false
        db.collection("Customer").document(customerID).collection("NewRequest").document(Auth.auth().currentUser!.uid).updateData([
                "state" : "تم الرفض"
            ])

        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    // then delet the cell ....

   
    
}

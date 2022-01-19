//
//  SignUpVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
class SignUpVC: UIViewController {
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var createbtn: UIButton!
    @IBOutlet weak var hostSwitch: UISwitch!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostSwitch.isOn = false
        hideKeyboard(view: view)
        roundCorners(view: subview)
        
    }
    
    //MARK: @IBActions
    
    @IBAction func createUser(_ sender: Any) {
        
        signUp()
        
    }
    
    //MARK: Functions
    
    func signUp() {
        
        if pass.text != "" && email.text != "" && phoneNumber.text != "" && name.text != "" {
            Auth.auth().createUser(withEmail:email.text! , password: pass.text!) { user, error in
                if error == nil {
                    print("user has been created")
                    if self.hostSwitch.isOn == true{
                        self.addHostData()
                    }else if self.hostSwitch.isOn == false {
                        self.addCustomerData()
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartVCid") as! StartVC
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                }else{
                    print(error)
                }
            }
            
        }else{
            
            let alert = UIAlertController(title: "missing information", message: "Please enter email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
   }
    
    
    
    func addHostData() {
        
        db.collection("Host").document("\(Auth.auth().currentUser!.uid)").setData([
            "name": name.text,
            "phoneNumber": phoneNumber.text,
            "NewSpace": "***",
            "id": Auth.auth().currentUser?.uid
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    func addCustomerData() {
        
        db.collection("Customer").document("\(Auth.auth().currentUser!.uid)").setData([
            "name": name.text,
            "phoneNumber": phoneNumber.text,
            "request": "***",
            "id": Auth.auth().currentUser?.uid
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    

    
    
}
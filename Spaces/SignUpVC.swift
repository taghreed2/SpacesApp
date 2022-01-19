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
        print(Auth.auth().currentUser?.uid)
    
        createbtn.layer.shadowColor = UIColor.gray.cgColor
        createbtn.layer.shadowRadius = 20
        createbtn.layer.shadowOpacity = 0.3
        createbtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        hideKeyboard(view: view)
        roundCorners(view: subview)
        
    }
    
    
    
    
    
    
    //MARK: @IBActions
    
    @IBAction func createUser(_ sender: Any) {
        // if cu?.uid == nil cuz it will take the user id if its loged in
     signUp()
    }
    
    
    
    
  
    
    
    //MARK: Functions
    
    func changeRequest() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = self.name.text
        changeRequest?.commitChanges { (error) in
            if error == nil {
                print("displayName done")
                print(Auth.auth().currentUser?.displayName)
            }else{
                print(error)
            }
        }
    }
 
    
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

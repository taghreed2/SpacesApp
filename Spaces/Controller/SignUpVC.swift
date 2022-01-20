//
//  SignUpVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase
class SignUpVC: UIViewController {
    
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
                    self.present(vc, animated: false, completion: nil)
                    
                }else{
                    
                    let alert = UIAlertController(title: "خطأ!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }else{
            
            let alert = UIAlertController(title: "معلومات مفقودة", message: "الرجاء ادخال البريد الإلكتروني وكلمة المرور", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
   }
    
    
    
    func addHostData() {
        
        db.collection("Host").document("\(Auth.auth().currentUser!.uid)").setData([
            "name": name.text ?? "name",
            "phoneNumber": phoneNumber.text ?? "phoneNumber",
            "NewSpace": "***",
            "id": Auth.auth().currentUser!.uid
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
            "name": name.text ?? "no name",
            "phoneNumber": phoneNumber.text ?? "no phoneNumber",
            "request": "***",
            "id": Auth.auth().currentUser?.uid ?? "no id"
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    

    
    
}

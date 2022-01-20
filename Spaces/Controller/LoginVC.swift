//
//  LoginVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
   
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        check()
        hideKeyboard(view: view)
        
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        logIn()
        
    }
    
   //MARK: Functiond
    
    func check(){
        
        if Auth.auth().currentUser?.uid != nil {
            DispatchQueue.main.async(){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartVCid") as! StartVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)            }
        }else{
            print("please login")
        }
    }
    
    func logIn(){
        
        if email.text != "" && pass.text != "" {
            Auth.auth().signIn(withEmail: email.text!, password: pass.text!) { user, error in
                if error == nil {
                    print("log in")
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
    
    
    
    
}

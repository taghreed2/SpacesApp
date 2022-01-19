//
//  LoginVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        check()
        hideKeyboard(view: view)
        roundCorners(view: subview)
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        logIn()
        
    }
    
   //MARK: Functiond
    
    func check(){
        
        if Auth.auth().currentUser?.uid != nil {
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "toStartVC", sender: self)
            }
        }else{
            print("please login")
        }
    }
    
    func logIn(){
        
        if email.text != "" && pass.text != "" {
            Auth.auth().signIn(withEmail: email.text!, password: pass.text!) { user, error in
                if error == nil {
                    print("log in")
                    self.performSegue(withIdentifier: "toStartVC", sender: self)
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
    
    
    
    
}

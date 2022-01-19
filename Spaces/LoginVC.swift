//
//  LoginVC.swift
//  Spaces
//
//  Created by TAGHREED on 29/05/1443 AH.
//

import UIKit
import Firebase

//move ..
func hideKeyboard(view:UIView){
    
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
    
}

func roundCorners(view:UIView) {
    view.layer.cornerRadius = 40
    }

func roundCorners2(view:UIView) {
    view.layer.cornerRadius = 20
    }

//...
class LoginVC: UIViewController {

    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser?.uid)
        check()
        hideKeyboard(view: view)
        roundCorners(view: subview)

    }
   

    @IBAction func login(_ sender: Any) {
        logIn()
    }
    
    
   
    
    
    
    
    
    
    

    
    
    
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  RegisterViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 29/04/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text  {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    self.alertWithError(error: e.localizedDescription)
                } else {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func alertWithError(error: String){
        let alert = UIAlertController(title: "Register Failed", message: error, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) {(action) in
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

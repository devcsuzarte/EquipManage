//
//  LoginViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 29/04/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                    self?.alertWithError(error: e.localizedDescription)
                } else {
                    self!.performSegue(withIdentifier: K.homeSegue, sender: self)
                }
            }
        }
    }
    
    func alertWithError(error: String){
        let alert = UIAlertController(title: "Login Failed", message: error, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) {(action) in
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

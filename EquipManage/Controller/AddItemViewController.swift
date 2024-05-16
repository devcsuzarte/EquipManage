//
//  AddItemViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 29/04/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddItemViewController: UIViewController {
    
    var currentCategoryID: String?
    var currentCategory: String?
    var itemsCounter: Int?
    
    let db = Firestore.firestore()
    
    var newItem = Item()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var labelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
       // print(">>>>>>ITEMS COUNT: \(itemsCounter!)")
            }
    
    @IBAction func addItemButtonPressed(_ sender: UIButton) {
        
        newItem.category = currentCategory
        newItem.title = titleTextField.text
        newItem.onwer = ownerTextField.text
        newItem.depatarment = departmentTextField.text
        newItem.id = 0
        
        if let category = newItem.category,
            let title = newItem.title,
            let owner = newItem.onwer,
            let department = newItem.depatarment,
            let id = newItem.id,
            let user = Auth.auth().currentUser?.email{
            
            db.collection("items@\(user)").addDocument(data: [
                "category": category,
                "title": title,
                "owner": owner,
                "department": department,
                "id": id
                
            ]) {(error) in
                if let e = error {
                    print("Erro to send data: \(e)")
                } else {
                    print("Sucessfully send data")
                    self.updateCount()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }
        
    }
    
    
    
    func updateCount(){
        
        if let id = currentCategoryID, let currentCount = itemsCounter, let user = Auth.auth().currentUser?.email{
            db.collection("categorys@\(user)").document(id).updateData([
                "countField": currentCount + 1
            ]) {(error) in
                if let e = error {
                    print("Erro to update data \(e)")
                } else {
                    print("Sucessfully update data")
                }
            }
        }
        
    }
}

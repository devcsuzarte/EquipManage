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
    var dataManager = DataManager()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var labelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
            }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIButton) {
        
        newItem.category = currentCategory
        newItem.title = titleTextField.text
        newItem.onwer = ownerTextField.text
        newItem.depatarment = departmentTextField.text
        newItem.id = 0
        
        if let categoryID = currentCategoryID, let count = itemsCounter {
            dataManager.addItem(newItem, categoryID, count)
            self.dismiss(animated: true, completion: nil)
        }
    
    }
}

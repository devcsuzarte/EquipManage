//
//  HomeTableViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 26/04/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class HomeTableViewController: UITableViewController {
            
    let db = Firestore.firestore()
    
    var cat: [Category] = []
    var sendCategoryName: String?
    var sendCategoryID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("heei I appear")
        loadCategorys()
    }
    
        // MARK: - Firebase
    
    func loadCategorys() {
        
        cat = []
        
        if let user = Auth.auth().currentUser?.email{
  
            
            db.collection("categorys@\(user)")
                .order(by: "titleField")
                .getDocuments
            {querySnapshot, error in
                    
                    if let e = error {
                        print("There was an issue to try get data from FireStore: \(e)")
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let categoryName = data["titleField"] as? String, let count = data["countField"] as? Int {
                                    let loadedCat = Category(title: categoryName, counter: count, categoryID: doc.documentID)
                                    self.cat.append(loadedCat)
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            
           
        }
    }
    
        // MARK: - Add Category
    @IBAction func addCatButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            var newItem = Category()
            newItem.title = textField.text!
            newItem.counter = 0
            
            
            if let title = newItem.title, let count = newItem.counter, let user = Auth.auth().currentUser?.email {
                
                self.db.collection("categorys@\(user)").addDocument(data: [
                    "titleField": title,
                    "countField": count
                ]) {(error) in
                    if let e = error {
                        print("Erro to send data: \(e)")
                    } else {
                        print("Sucessfully send data")
                    }
                }
                
                self.loadCategorys()
                
            }
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cat.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = cat[indexPath.row].title!
        cell.detailTextLabel?.text = String(cat[indexPath.row].counter!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        sendCategoryName = cat[indexPath.row].title!
        sendCategoryID = cat[indexPath.row].categoryID!
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemsViewController
        
        if let getCategoryName = sendCategoryName,  let getCategoryID = sendCategoryID{
            destinationVC.selectedCategory = getCategoryName
            destinationVC.categoryID = getCategoryID
        }
    }
}


/*
 
 db.collection("categorys@\(user)")
     .addSnapshotListener {querySnapshot, error in
         
         if let e = error {
             print("There was an issue to try get data from FireStore: \(e)")
         } else {
             if let snapshotDocuments = querySnapshot?.documents {
                 for doc in snapshotDocuments {
                     let data = doc.data()
                     if let categoryName = data["titleField"] as? String, let count = data["countField"] as? Int {
                         let loadedCat = Category(title: categoryName, count: count)
                         self.cat.append(loadedCat)
                         
                         DispatchQueue.main.async {
                             self.tableView.reloadData()
                         }
                     }
                 }
             }
         }
     }
 */

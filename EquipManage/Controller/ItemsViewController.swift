//
//  ItemsViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 28/04/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ItemsViewController: UITableViewController {

    
    let db = Firestore.firestore()
    var items = [Item]()
    var selectedCategory: String?
    var categoryID: String?
    var itemID: String?
    var selectedIndex: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        tableView.dataSource = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
    }
    
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.addSegue, sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemsCell, for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title!
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.detailTextLabel?.text = "\(items[indexPath.row].onwer!) - \(items[indexPath.row].depatarment!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        selectedIndex = indexPath.row
                
        performSegue(withIdentifier: K.reportsSegue, sender: self)
    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == K.reportsSegue {
            let destinationVC = segue.destination as! ReportsTableViewController
            
            if let i =  selectedIndex {
                destinationVC.currentItemID = items[i].docID
            }
            
        }
    }
    
        // MARK: - FIREBASE
    
    func loadItems() {
                
        if let user = Auth.auth().currentUser?.email, let categoryName = selectedCategory{
            
            db.collection(K.FStore.itemsCollection + user)
                .whereField(K.FStore.itemsCategory, isEqualTo: categoryName)
                .addSnapshotListener {querySnapshot, error in
                    
                    if let e = error {
                        print("There was an issue to try get data from FireStore: \(e)")
                    } else {
                        self.items = []
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let category = data[K.FStore.itemsCategory] as? String,
                                   let title = data[K.FStore.itemsTitle] as? String,
                                   let owner = data[K.FStore.itemsOwner] as? String,
                                   let department = data[K.FStore.itemsDepartment] as? String,
                                   let itemID = data[K.FStore.itemsId] as? Int
                                {
                                    let loadedItem = Item(category: category, title: title, id: itemID, docID: doc.documentID, onwer: owner, depatarment: department)
                                    print("------ITEM LOADED: \(loadedItem)")
                                    self.items.append(loadedItem)
                                    
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
}

 /*/
  let washingtonRef = db.collection("cities").document("DC")

  // Atomically add a new region to the "regions" array field.
  washingtonRef.updateData([
    "regions": FieldValue.arrayUnion(["greater_virginia"])
  ])

  // Atomically remove a region from the "regions" array field.
  washingtonRef.updateData([
    "regions": FieldValue.arrayRemove(["east_coast"])
  ])
  
  if segue.identifier == "goToAddItem" {
      let destinationVC = segue.destination as! AddItemViewController
      
      if let categoryToItem = selectedCategory, let id = categoryID {
          destinationVC.currentCategory = categoryToItem
          destinationVC.currentCategoryID = id
          destinationVC.itemsCounter = items.count
      }
      
  } else
  
  */

//
//  ItemsViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 28/04/24.
//

import UIKit

class ItemsViewController: UITableViewController, AddItemDelegate {

    var itemsList: [Item]?
    var selectedCategory: String?
    var categoryID: String?
    var itemID: String?
    var selectedIndex: Int?
    
    var dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        tableView.dataSource = self
        
        getItemsList()
        

    }
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.addSegue, sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemsCell, for: indexPath)
        
        if let item = itemsList?[indexPath.row] {
            cell.textLabel?.text = item.title!
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.detailTextLabel?.text = "\(item.onwer!) - \(item.depatarment!)"
        } else {
            cell.textLabel?.text = "No items"
            cell.textLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemsCell, for: indexPath)
        
        if itemsList != nil {
            selectedIndex = indexPath.row
            performSegue(withIdentifier: K.reportsSegue, sender: self)
        }

    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      
      if segue.identifier == K.addSegue {
          let destinationVC = segue.destination as! AddItemViewController
          
          destinationVC.delegate = self
          
          if let categoryToItem = selectedCategory, let id = categoryID, let items = itemsList {
              destinationVC.currentCategory = categoryToItem
              destinationVC.currentCategoryID = id
              destinationVC.itemsCounter = items.count
          }
          
      }
      
      if segue.identifier == K.reportsSegue {
            let destinationVC = segue.destination as! ReportsTableViewController
            
          if let i =  selectedIndex, let items = itemsList {
                destinationVC.currentItemID = items[i].docID
            }
            
        }
    }
    
    
    func didItemWasAdd() {
        print("Did Report Was Add")
        getItemsList()
    }
    
        // MARK: - Get Items List
    
    func getItemsList(){
        
        if let currentCategory = selectedCategory {
            dataManager.loadItems(for: currentCategory) { items in
                if items.count > 0 {
                    self.itemsList = items
                    self.tableView.reloadData()
                }
            }
        }
    }
}

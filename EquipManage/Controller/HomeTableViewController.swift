//
//  HomeTableViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 26/04/24.
//

import UIKit

class HomeTableViewController: UITableViewController, DataManagerCategory {
            
    var cat: [Category]?
    var sendCategoryName: String?
    var sendCategoryID: String?
    var dataManager = DataManager()
    
    @IBOutlet weak var searchCategoryBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true

        tableView.dataSource = self
        dataManager.categoryDelagte = self
        getCategorysList()
    }
    
        // MARK: - Get Categorys
    
    func getCategorysList(){
        
        dataManager.loadCategorys { category in
            if category.count > 0 {
                self.cat = category
                self.tableView.reloadData()
            }
        }
        
    }
    
    func didCategoryWasAdd() {
        getCategorysList()
    }
    
    
        // MARK: - Add Category
    @IBAction func addCatButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {(action) in
            
            var newItem = Category()
            newItem.title = textField.text!
            newItem.counter = 0
            
            self.dataManager.addCategory(newItem)
            
        }
        
        let actionDismiss = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(actionDismiss)
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
        return cat?.count ?? 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categotyCell, for: indexPath)
        
        if let category = cat?[indexPath.row] {
            cell.textLabel?.text = category.title
            cell.textLabel?.textColor = .label
            cell.detailTextLabel?.text = String(category.counter!)
        } else {
            cell.textLabel?.text = "No categorys"
            cell.textLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let category = cat?[indexPath.row] {
            
            sendCategoryName = category.title!
            sendCategoryID = category.categoryID!
            
            performSegue(withIdentifier: K.itemsSegue, sender: self)
        }
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemsViewController
        
        if let getCategoryName = sendCategoryName,  let getCategoryID = sendCategoryID{
            print(getCategoryName)
            destinationVC.selectedCategory = getCategoryName
            destinationVC.categoryID = getCategoryID
        }
    }
}

extension HomeTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var filteredList: [Category] = []
        
        if let categorys = cat {
            for category in categorys {
                if category.title!.contains(searchBar.text!){
                    filteredList.append(category)
                }
            }
            
            cat = filteredList
            tableView.reloadData()
            
        }
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            getCategorysList()
        }
    }
}

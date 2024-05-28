//
//  RegisterTableViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 08/05/24.
//

import UIKit

class ReportsTableViewController: UITableViewController, AddReportDelegate{
    
    var dataManager = DataManager()
    
    var reportsList: [Report] = []
    var currentItemID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        getReports()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.addReportSegue {
            let destinationVC = segue.destination as! AddReportViewController
            destinationVC.delegate = self
            
            if let id = currentItemID {
                destinationVC.itemID = id
            }
        }
    }
    
    
    
    func getReports(){
        if let id = currentItemID{
                dataManager.loadReports(for: id) { report in
                    self.reportsList = report
                    self.tableView.reloadData()
                }
        }
    }
  
    func didReportWasAdd() {
        getReports()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return reportsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reportsCell, for: indexPath)
        
        cell.textLabel?.text = reportsList[indexPath.row].reportText
        cell.detailTextLabel?.text = "Last update: \(reportsList[indexPath.row].date!)"
        
        return cell
    }
}

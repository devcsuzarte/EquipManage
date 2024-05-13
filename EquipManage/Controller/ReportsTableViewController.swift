//
//  RegisterTableViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 08/05/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

protocol ReportsDelegate {
    func didUpdateReports()
}

class ReportsTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var reportsList: [Report] = []
    var currentItemID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        if let id = currentItemID{
            
            print(id)
            loadReports()
        }
    }
    
        // MARK: - Add Button Alert
    @IBAction func addCatButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Report", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Report", style: .default) {(action) in
            
            var newReport = Report()
            newReport.reportText = textField.text
            newReport.date = String(Date().timeIntervalSince1970)
            newReport.reportItemID = self.currentItemID
            
            if let reportDate = newReport.date, let txt = newReport.reportText {
                self.addReport(newReport)
            }

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new report"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
        // MARK: - Firebase Methods
    
    func addReport(_ report: Report){
        
        
        if let text = report.reportText, let date = report.date, let id = report.reportItemID, let user = Auth.auth().currentUser?.email {
            
            self.db.collection("reports@\(user)").addDocument(data: [
                "description": text,
                "date": date,
                "itemID": id
            ]) {(error) in
                if let e = error {
                    print("Erro to send data: \(e)")
                } else {
                    print("Sucessfully send data")
                }
            }
            
            self.loadReports()
            
        }
    }
    
    func loadReports(){
        if let user = Auth.auth().currentUser?.email, let id = currentItemID{
            
            db.collection("reports@\(user)")
                .whereField("itemID", isEqualTo: id)
                .addSnapshotListener {querySnapshot, error in
                    if let e = error {
                        print("There was an issue to try get data from FireStore: \(e)")
                    } else {
                        self.reportsList = []
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let date = data["date"] as? String,
                                   let description = data["description"] as? String,
                                   let id = data["itemID"] as? String
                                  
                                {
                                    let loadedReport = Report(date: date, reportText: description, reportItemID: id)
                                    print(">>>>>>REPORT LOADED: \(loadedReport)")
                                    self.reportsList.append(loadedReport)
                                    
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return reportsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath)
        
        cell.textLabel?.text = reportsList[indexPath.row].reportText
        print(reportsList[indexPath.row].date!)

        return cell
    }
}

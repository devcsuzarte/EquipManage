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
   /* @IBAction func addReportButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Report", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Report", style: .default) {(action) in
            
            var newReport = Report()
            newReport.reportText = textField.text
            newReport.time = String(Date().timeIntervalSince1970)
            newReport.reportItemID = self.currentItemID
            
            if let reportTime = newReport.time, let txt = newReport.reportText {
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
        
        var currentDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let formattedDate = dateFormatter.string(from: Date())
            return formattedDate
        }
        
        if let text = report.reportText, let time = report.time, let id = report.reportItemID, let user = Auth.auth().currentUser?.email {
            
            self.db.collection(K.FStore.reportsCollection + user)
                .addDocument(data: [
                K.FStore.reportDescription: text,
                K.FStore.reportDate: currentDate,
                K.FStore.reportTime: time,
                K.FStore.reportItemID: id
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
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.addReportSegue {
            
            let destinationVC = segue.destination as! AddReportViewController
            
            if let id = currentItemID {
                destinationVC.itemID = id
            }
        }
    }
    
    func loadReports(){
        if let user = Auth.auth().currentUser?.email, let id = currentItemID{
            
            db.collection(K.FStore.reportsCollection + user)
                .order(by: K.FStore.reportTime, descending: true)
                .whereField(K.FStore.reportItemID, isEqualTo: id)
                .addSnapshotListener {querySnapshot, error in
                    if let e = error {
                        print("There was an issue to try get data from FireStore: \(e)")
                    } else {
                        self.reportsList = []
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let date = data[K.FStore.reportDate] as? String,
                                   let description = data[K.FStore.reportDescription] as? String,
                                   let id = data[K.FStore.reportItemID] as? String
                                  
                                {
                                    let loadedReport = Report( date: date, reportText: description, reportItemID: id)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reportsCell, for: indexPath)
        
        cell.textLabel?.text = reportsList[indexPath.row].reportText
        cell.detailTextLabel?.text = "Last update: \(reportsList[indexPath.row].date!)"
        
        return cell
    }
}

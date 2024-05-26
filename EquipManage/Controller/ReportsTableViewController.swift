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

class ReportsTableViewController: UITableViewController, ReportDelegate{
        
    let db = Firestore.firestore()
    var addReport = AddReportViewController()
    var dataManager = DataManager()
    
    var reportsList: [Report] = []
    var currentItemID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        addReport.delegate = self
     //   dataManager.delegate = self
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
                    print("\\\\\\\\\\THIS WAS GETTED BY GET REPORTS")
                    print(report)
                    self.reportsList = report
                    self.tableView.reloadData()
                    
                }
        }
    }
    /*
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
                                    //print(">>>>>>REPORT LOADED: \(loadedReport)")
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
    }*/
    
    func didReportWasAdd() {
        print("oiii")
        
        //getReports()
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

//
//  AddReportViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 20/05/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AddReportViewController: UIViewController {
    
    var itemID: String?
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var reportTextView: UITextView!
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        var report = Report()
        report.reportText = reportTextView.text
        report.reportItemID = itemID
      
            var currentDate: String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                let formattedDate = dateFormatter.string(from: Date())
                return formattedDate
            }
            
            if let text = report.reportText,let id = report.reportItemID, let user = Auth.auth().currentUser?.email {
                
                db.collection(K.FStore.reportsCollection + user)
                    .addDocument(data: [
                        K.FStore.reportDescription: text,
                        K.FStore.reportDate: currentDate,
                        K.FStore.reportTime: Date().timeIntervalSince1970,
                        K.FStore.reportItemID: id
                    ]) {(error) in
                        if let e = error {
                            print("Erro to send data: \(e)")
                        } else {
                            print("Sucessfully send data")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                
                
            }
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

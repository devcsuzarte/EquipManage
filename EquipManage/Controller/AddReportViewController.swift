//
//  AddReportViewController.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 20/05/24.
//

import UIKit

protocol AddReportDelegate {
    func didReportWasAdd()
}

class AddReportViewController: UIViewController {
    
    var itemID: String?
    
    var dataManager = DataManager()
    var delegate: AddReportDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var reportTextView: UITextView!
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        var report = Report()
        report.reportText = reportTextView.text
        report.reportItemID = itemID
      
    
        if let text = report.reportText,let id = report.reportItemID {
                dataManager.addReport(with: text, for: id)
                delegate?.didReportWasAdd()
                self.dismiss(animated: true, completion: nil)
            }
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

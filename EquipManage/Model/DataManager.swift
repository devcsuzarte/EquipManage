//
//  DataManager.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 22/05/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class DataManager {
    
    
    let db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser?.email
    
    
    
    
 
    
    func loadReports(for currentId: String?, completion: @escaping ([Report]) -> Void){
        
        
        if let user = currentUser, let id = currentId{
            
            db.collection(K.FStore.reportsCollection + user)
                .order(by: K.FStore.reportTime, descending: true)
                .whereField(K.FStore.reportItemID, isEqualTo: id)
                .addSnapshotListener {querySnapshot, error in
                    if let e = error {
                        print("There was an issue to try get data from FireStore: \(e)")
                    } else {
                        var reportsList: [Report] = []
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let date = data[K.FStore.reportDate] as? String,
                                   let description = data[K.FStore.reportDescription] as? String,
                                   let id = data[K.FStore.reportItemID] as? String
                                  
                                {
                                    let loadedReport = Report( date: date, reportText: description, reportItemID: id)
                                    //print(">>>>>>REPORT LOADED: \(loadedReport)")
                                    reportsList.append(loadedReport)
                                    
                                }
                            }
                        }
                        
                            completion(reportsList)
                 
                    }
                }
        } else {
            print("Não pegou")
            completion([])
        }
    }
}

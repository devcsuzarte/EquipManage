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

protocol DataManagerDelegate{
    func didUpdateSomething()
}

class DataManager {
    
    let db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser?.email
    
    var delegate: DataManagerDelegate?
    
    func loadItems(){
        print("items loaded")
        delegate?.didUpdateSomething()
    }

    
}

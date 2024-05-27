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


protocol DataManagerCategory{
    func didCategoryWasAdd()
}

protocol DataManagerItem{
    func didItemWasAdd()
}

protocol DataManagerReport{
    func didReportWasAdd()
}
class DataManager {
    
    
    let db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser?.email
    
    var categoryDelagte: DataManagerCategory?
    var itemDelagte: DataManagerItem?
    var reportDelegate: DataManagerReport?
    
    // MARK: - LOAD CATEGORYS
    
    func loadCategorys(completion: @escaping ([Category]) -> Void){
        
        var categorysList:[Category] = []
        
        if let user = currentUser{
            db.collection(K.FStore.categorysCollection + user)
                .order(by: K.FStore.titleField)
                .getDocuments
            {querySnapshot, error in
                    if let e = error {
                        print("There was an issue to try get data from FireStore: \(e)")
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let categoryName = data[K.FStore.titleField] as? String, let count = data[K.FStore.countField] as? Int {
                                    let loadedCat = Category(title: categoryName, counter: count, categoryID: doc.documentID)
                                    categorysList.append(loadedCat)
                                }
                            }
                        }
                        completion(categorysList)
                    }
                }
            
           
        } else {
            completion([])
        }
        
    }
    
    // MARK: ADD CATEGORY
    
    func addCategory(_ newCategory: Category){
        
        if let user = currentUser, let title = newCategory.title, let count = newCategory.counter {
            self.db.collection(K.FStore.categorysCollection + user).addDocument(data: [
                K.FStore.titleField: title,
                K.FStore.countField: count
            ]) {(error) in
                if let e = error {
                    print("Erro to send data: \(e)")
                } else {
                    print("Sucessfully send data")
                    self.categoryDelagte?.didCategoryWasAdd()
                }
            }
        }
    }
    
    // MARK: - LOAD ITEMS
    
    func loadItems(for currentCategory: String?, completion: @escaping ([Item]) -> Void){
        
        if let user = currentUser, let category = currentCategory {
            db.collection(K.FStore.itemsCollection + user)
                .whereField(K.FStore.itemsCategory, isEqualTo: category)
                .addSnapshotListener {querySnapshot, error in
                    
                    if let e = error {
                        print("There was an issue to try get data from FireStore: \(e)")
                    } else {
                        var itemsList: [Item] = []
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let category = data[K.FStore.itemsCategory] as? String,
                                   let title = data[K.FStore.itemsTitle] as? String,
                                   let owner = data[K.FStore.itemsOwner] as? String,
                                   let department = data[K.FStore.itemsDepartment] as? String,
                                   let itemID = data[K.FStore.itemsId] as? Int
                                {
                                    let loadedItem = Item(category: category, title: title, id: itemID, docID: doc.documentID, onwer: owner, depatarment: department)
        
                                    itemsList.append(loadedItem)
                                }
                            }
                        }
                        
                        completion(itemsList)
                    }
                }
        }
    }
    
    
    // MARK: ADD CATEGORY
    
    func addItem(_ newItem: Item, _ categoryID: String, _ currentCount: Int){
        
        if let category = newItem.category,
            let title = newItem.title,
            let owner = newItem.onwer,
            let department = newItem.depatarment,
            let id = newItem.id,
            let user = currentUser {
            
            db.collection(K.FStore.itemsCollection + user).addDocument(data: [
                K.FStore.itemsCategory: category,
                K.FStore.itemsTitle: title,
                K.FStore.itemsOwner: owner,
                K.FStore.itemsDepartment: department,
                K.FStore.itemsId: id
                
            ]) {(error) in
                if let e = error {
                    print("Erro to send data: \(e)")
                } else {
                    print("Sucessfully send data")
                    self.db.collection(K.FStore.categorysCollection + user)
                        .document(categoryID).updateData([
                            K.FStore.countField: currentCount + 1
                        ]) {(error) in
                            if let e = error {
                                print("Erro to update data \(e)")
                            } else {
                                print("Sucessfully update data")
                            }
                        }
                }
            }
        } else {
            print("Erro to add item")
        }
    }
    
    func updateCount(_ categoryId: String, _ count: Int){
        if let user = currentUser {
            db.collection(K.FStore.categorysCollection + user)
                .document(categoryId).updateData([
                    K.FStore.countField: count + 1
                ]) {(error) in
                    if let e = error {
                        print("Erro to update data \(e)")
                    } else {
                        print("Sucessfully update data")
                    }
                }
        }
    }
    
    
    // MARK: - LOAD REPORTS
    
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

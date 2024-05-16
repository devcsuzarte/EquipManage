//
//  Constants.swift
//  EquipManage
//
//  Created by Claudio Suzarte on 16/05/24.
//

import Foundation

struct K {
    
    static let homeSegue = "loginToHome"
    static let itemsSegue = "goToItems"
    static let addSegue = "goToAddItem"
    static let reportsSegue = "goToReports"
    
    static let categotyCell = "categoryCell"
    static let itemsCell = "itemsCell"
    
    
    struct FStore {
        static let categorysCollection = "categorys@"
        static let titleField = "titleField"
        static let countField = "countField"
        
        static let itemsCollection = "items@"
        static let itemsCategory = "category"
        static let itemsTitle = "title"
        static let itemsOwner = "owner"
        static let itemsDepartment = "department"
        static let itemsId = "id"
        
    }
}

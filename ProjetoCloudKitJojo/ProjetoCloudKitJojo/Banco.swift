//
//  Banco.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 27/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import CloudKit

class Banco{
    /// container of database dashboard
    let container = CKContainer(identifier: "iCloud.mini4.com.jojo.seila")
    
    /**
     retrieve database data and added to the array
     */
    func read(){
        let database = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        
    }
    
}

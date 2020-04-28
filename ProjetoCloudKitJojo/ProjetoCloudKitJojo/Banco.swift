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
    static let container = CKContainer(identifier: "")
    
    static func read() -> [String]{
        let database = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        
    }
    
}

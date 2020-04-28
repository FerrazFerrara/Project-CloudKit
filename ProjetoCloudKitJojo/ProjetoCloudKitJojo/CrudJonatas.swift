//
//  CrudJonatas.swift
//  ProjetoCloudKitJojo
//
//  Created by Jonatas Coutinho de Faria on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import CloudKit

class Location{
    var recordID: CKRecord.ID
    var title: String
    var location: CLLocation
    
    init(){
        self.recordID = CKRecord.ID()
        self.title = String()
        self.location = CLLocation()
    }
    
    init(recordID: CKRecord.ID, title: String, location: CLLocation) {
        self.recordID = recordID
        self.title = title
        self.location = location
    }
}

class CrudJonatas{
        var publicDatabase: CKDatabase!
        
        init() {
             
            publicDatabase = CKContainer.init(identifier: "iCloud.Jonatas.ConnectMap").publicCloudDatabase
        }

        func createPlace(title : String, location: CLLocationCoordinate2D) {
            
            let record = CKRecord(recordType: "Location")
            
            record.setValue(title, forKey: "name")
            record.setValue(CLLocation(latitude: location.latitude, longitude: location.longitude), forKey:  "location")
            
            publicDatabase.save(record, completionHandler: { (savedRecord, error) in
                
                if error == nil {
                    print("Record Saved")
                    
                } else {
                    
                    print("Record Not Saved")
                    print(error!)
                    
                }
                
            })
        }
        
        func readPlace(completion: @escaping ([Location]) -> Void){
            let predicate = NSPredicate(value: true)
    //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur3")
            
            let query = CKQuery(recordType: "Location", predicate: predicate)
            query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
            
            let operation = CKQueryOperation(query: query)
            
            var locations = [Location]()
            
            operation.recordFetchedBlock = { record in
                
                locations.append(Location(recordID: record.recordID, title: record["name"]!, location: record["location"]!))
                
            }
            
            operation.queryCompletionBlock = { cursor, error in
                completion(locations)
            }
        
            publicDatabase.add(operation)
        }
        
        func deletePlace(locate: Location) {
            let recordID = locate.recordID
            
            publicDatabase.delete(withRecordID: recordID) { (deletedRecordID, error) in
                
                if error == nil {
                    print("Record Deleted")
                    
                } else {
                    print("Record Not Deleted")
                    
                }
            }
        }
}

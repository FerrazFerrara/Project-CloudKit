//
//  CRUDFerraz.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

/// array de itens do tipo string que vao ser guardados no banco
var titles = [String]()
/// array com os IDs de cada item guardado no banco
var recordIDs = [CKRecord.ID]()

class CRUDViewController: UIViewController {
    
    @IBOutlet weak var nomesTextField: UITextField!
    @IBOutlet weak var salaTextField: UITextField!
    
    let container = CKContainer(identifier: "iCloud.containerForTestFerrazRiR")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func saveBtn(_ sender: Any) {
        let privateDatabase = container.publicCloudDatabase
        
        if let name = nomesTextField.text{
            guard let codigoGrupo = salaTextField.text else { return }
            
            let title = name
            let record = CKRecord(recordType: "Names")
            record.setValue(title, forKey: "Names")
            record.setValue(codigoGrupo, forKey: "groupID")
            
            
            privateDatabase.save(record) { (savedRecord, error) in
                if error == nil {
                    print("Record Saved")
                } else {
//                    print(error)
                    print("Record Not Saved")
                }
            }
        } else {
            print("Nome me branco")
        }
    }
    
    @IBAction func retrieveBtn(_ sender: Any) {
        guard let codigoGrupo = salaTextField.text else { return }
        
        let privateDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Names", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        let operation = CKQueryOperation(query: query)
        titles.removeAll()
        recordIDs.removeAll()
        operation.recordFetchedBlock = { record in
            if codigoGrupo == record["groupID"]!{
                titles.append(record["Names"]!)
                recordIDs.append(record.recordID)
            }
        }
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                print("Titles: \(titles)")
                print("RecordIDs: \(recordIDs)")
            }
        }
        privateDatabase.add(operation)
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        let privateDatabase = container.publicCloudDatabase
        guard let newTitle = nomesTextField.text else { return }
        
        let recordID = recordIDs.first!
        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            if error == nil {
                record?.setValue(newTitle, forKey: "Names")
                
                privateDatabase.save(record!, completionHandler: { (newRecord, error) in
                    if error == nil {
                        print("Record Saved")
                    } else {
                        print("Record Not Saved")
                    }
                    
                })
            } else {
                print("Could not fetch record")
            }
        }
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let privateDatabase = container.publicCloudDatabase
        let recordID = recordIDs.first!
        privateDatabase.delete(withRecordID: recordID) { (deletedRecordID, error) in
            
            if error == nil {
                print("Record Deleted")
            } else {
                print("Record Not Deleted")
            }
        }
    }
}

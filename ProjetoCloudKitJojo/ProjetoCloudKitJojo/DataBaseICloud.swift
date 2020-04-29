//
//  DataBaseICloud.swift
//  ProjetoCloudKitJojo
//
//  Created by Jonatas Coutinho de Faria on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class DataBaseICloud{
    
    static let shared = DataBaseICloud()
    
    let container = CKContainer(identifier: "iCloud.mini4.com.jojo.seila")
    
    var usuarios = [Usuario]()
    var atividades = [CKRecord]()
    var familia: Familia?
    
    //Initializer access level change now
    private init(){}
    
    
    // MARK: - CRUD USUÁRIO
    
    func createUser(idFamilia: String, nome: String, pontuacao: Int, foto: UIImage, conquista: [Bool], vitoria: Int, derrota: Int){
        
        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "Usuario")
        
        record.setValue(idFamilia, forKey: "idFamilia")
        record.setValue(nome, forKey: "nome")
        record.setValue(pontuacao, forKey: "pontuacao")
        record.setValue(foto, forKey: "foto")
        record.setValue(conquista, forKey: "conquista")
        record.setValue(vitoria, forKey: "vitoria")
        record.setValue(derrota, forKey: "derrota")
        
        database.save(record) { (recordSave, error) in
            if error == nil{
                print("Yaaay salvou um usuario")
            } else {
                print("usuario nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    func updateUser(){
        
    }
    
    func retrieveUser(){
        let database = self.container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        let operation = CKQueryOperation(query: query)
        
        operation.recordFetchedBlock = { record in
            
        }
        
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                print(self.usuarios)
            }
        }
        
//        guard let codigoGrupo = salaTextField.text else { return }
//
//        let privateDatabase = container.publicCloudDatabase
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Names", predicate: predicate)
//        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
//        let operation = CKQueryOperation(query: query)
//        titles.removeAll()
//        recordIDs.removeAll()
//        operation.recordFetchedBlock = { record in
//            if codigoGrupo == record["groupID"]!{
//                titles.append(record["Names"]!)
//                recordIDs.append(record.recordID)
//            }
//        }
//        operation.queryCompletionBlock = { cursor, error in
//            DispatchQueue.main.async {
//                print("Titles: \(titles)")
//                print("RecordIDs: \(recordIDs)")
//            }
//        }
//        privateDatabase.add(operation)
    }
    
    func deleteUser(usuario: Usuario){
        
        let database = container.publicCloudDatabase
        let recordID = usuario.recordID
        
        database.delete(withRecordID: recordID) { (deletedRecordID, error) in
            
            if error == nil {
                print("Deletado")
                
            } else {
                print("Nao deletou...")
                print(error as Any)
            }
        }
    }
    
    
    // MARK: - CRUD FAMÍLIA
    
    func createFamilia(){
        
    }
    
    func updateFamilia(){
        
    }
    
    func retrieveFamilia(){
        
    }
    
    func deleteFamilia(){
        
    }
    
    
    // MARK: - CRUD ATIVIDADE
    
    func createAtividade(nome: String, pontuacao: Int, dia: Date, horario: Date, repete: Int, etiqueta: String){
        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "Atividade")
        
        record.setValue(nome, forKey: "nome")
        record.setValue(pontuacao, forKey: "pontuacao")
        record.setValue(dia, forKey: "dia")
        record.setValue(horario, forKey: "horario")
        record.setValue(repete, forKey: "repeticao")
        record.setValue(etiqueta, forKey: "etiqueta")
        record.setValue(false, forKey: "realizou")
        
//        record.setValue(, forKey: "dataFeito")
//        record.setValue(, forKey: "usuario")
        
        database.save(record) { (recordSave, error) in
            if error == nil{
                print("Yaaay salvou uma atividade")
            } else {
                print("Atividade nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    func updateAtividade(){
        
    }
    
    func retrieveAtividade(){
//        let database = self.container.publicCloudDatabase
//
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Atividade", predicate: predicate)
//
//        query.sortDescriptors = [NSSortDescriptor(key: "pontuacao", ascending: false)]
//
//        let operation = CKQueryOperation(query: query)
//
//        var asdasd = CKRecord(recordType: "Atividade", recordID: <#T##CKRecord.ID#>)
//
//        self.atividades.removeAll()
//
//        operation.recordFetchedBlock = { record in
//            self.atividades.append(record)
//            CKRecord.Reference(record: record, action: CKRecord_Reference_Action.none)
//        }
        
//        let atividade = CKRecord(recordType: "")
//
//        self.container.publicCloudDatabase.fetch(withRecordID: ,completionHandler: <#T##(CKRecord?, Error?) -> Void#>)
        
        
//        guard let codigoGrupo = salaTextField.text else { return }
//
//        let privateDatabase = container.publicCloudDatabase
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Names", predicate: predicate)
//        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
//        let operation = CKQueryOperation(query: query)
//        titles.removeAll()
//        recordIDs.removeAll()
//        operation.recordFetchedBlock = { record in
//            if codigoGrupo == record["groupID"]!{
//                titles.append(record["Names"]!)
//                recordIDs.append(record.recordID)
//            }
//        }
//        operation.queryCompletionBlock = { cursor, error in
//            DispatchQueue.main.async {
//                print("Titles: \(titles)")
//                print("RecordIDs: \(recordIDs)")
//            }
//        }
//        privateDatabase.add(operation)
    }
    
    func deleteAtividade(){
        
    }
    
    
}

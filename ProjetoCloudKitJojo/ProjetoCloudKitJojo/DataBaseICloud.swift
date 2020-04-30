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
    var atividades = [Atividade]()
    var familia: Familia?
    
    //Initializer access level change now
    private init(){}
    
    // MARK: - CRUD USUÁRIO
    
    func createUser(idFamilia: String, nome: String, pontuacao: Int, conquista: [Bool], vitoria: Int, derrota: Int, foto: UIImage){
        
        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "Usuario")
        
        let data = foto.pngData();
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data!.write(to: url!)
            let asset = CKAsset(fileURL: url!)
            record.setValue(asset, forKey: "foto")
        } catch let e as NSError {
            print("Error! \(e)");
            return
        }
        
        record.setValue(idFamilia, forKey: "idFamilia")
        record.setValue(nome, forKey: "nome")
        record.setValue(pontuacao, forKey: "pontuacao")
        record.setValue(conquista, forKey: "conquista")
        record.setValue(vitoria, forKey: "vitoria")
        record.setValue(derrota, forKey: "derrota")
        
        let user = Usuario(recordID: record.recordID, idFamilia: idFamilia, nome: nome, pontuacao: pontuacao, foto: foto, conquista: conquista, vitoria: vitoria, derrota: derrota)
        
        database.save(record) { (recordSave, error) in
            if error == nil{
                print("Yaaay salvou um usuario")
                self.usuarios.append(user)
            } else {
                print("usuario nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    func updateUser(novoNome: String){
        let database = self.container.publicCloudDatabase
        
        let recordUserIDFirst = self.usuarios.first!.recordID
        
        database.fetch(withRecordID: recordUserIDFirst) { (record, error) in
            if error == nil{
                record?.setValue(novoNome, forKey: "nome")
                
                database.save(record!) { (newRecord, error) in
                    if error == nil{
                        print("Deu update tranquilo aq")
                    } else {
                        print("Deu ruim no update aq bro")
                    }
                }
            } else {
                print("nao rolou de buscar os dados")
            }
        }
    }
    
    func retrieveUser(){
        let database = self.container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        let operation = CKQueryOperation(query: query)
        
        usuarios.removeAll()
        operation.recordFetchedBlock = { record in
            let user = Usuario(recordID: record.recordID, idFamilia: record["idFamilia"] as! NSString, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, foto: record["foto"] as! CKAsset, conquista: record["conquista"] as! [NSNumber], vitoria: record["vitoria"] as! NSNumber, derrota: record["derrota"] as! NSNumber)
            self.usuarios.append(user)
            
        }
        
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                print("=========================")
                print(self.usuarios)
                if error != nil{
                    print(error as Any)
                }
            }
        }
        
        database.add(operation)
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
    
    func createAtividade(nome: String, pontuacao: Int, dia: Date, horario: Date, repete: Int, etiqueta: String, user: Usuario){
        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "Atividade")
        
        let reference = CKRecord.Reference(recordID: user.recordID, action: CKRecord_Reference_Action.none)
        
        record.setValue(nome, forKey: "nome")
        record.setValue(pontuacao, forKey: "pontuacao")
        record.setValue(dia, forKey: "dia")
        record.setValue(horario, forKey: "horario")
        record.setValue(repete, forKey: "repeticao")
        record.setValue(etiqueta, forKey: "etiqueta")
        record.setValue(false, forKey: "realizou")
        
//        record.setValue(, forKey: "dataFeito")
        record.setValue(reference, forKey: "usuario")
        
        database.save(record) { (recordSave, error) in
            if error == nil{
                print("Yaaay salvou uma atividade")
            } else {
                print("Atividade nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    func updateAtividade(novoNome: String){
        let database = self.container.publicCloudDatabase
        
        let recordActivityIDFirst = self.atividades.first!.recordID
        
        database.fetch(withRecordID: recordActivityIDFirst) { (record, error) in
            if error == nil{
                record?.setValue(novoNome, forKey: "nome")
                
                database.save(record!) { (newRecord, error) in
                    if error == nil{
                        print("Deu update tranquilo aq")
                    } else {
                        print("Deu ruim no update aq bro")
                    }
                }
            } else {
                print("nao rolou de buscar os dados")
            }
        }
    }
    
    func retrieveAtividade(){
        let database = self.container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Atividade", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "pontuacao", ascending: true)]
        
        let operation = CKQueryOperation(query: query)
        
        atividades.removeAll()
        
        operation.recordFetchedBlock = { record in
            let activity = Atividade(recordID: record.recordID, dia: record["dia"] as! NSDate, etiqueta: record["etiqueta"] as! NSString, horario: record["horario"] as! NSDate, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, repeticao: record["repeticao"] as! NSNumber, usuario: nil, dataFeito: record["dataFeito"] as! NSDate, realizou: record["realizou"] as! NSNumber)
            
            self.atividades.append(activity)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error == nil {
                    print("Atividade recuperada")
                    
                } else {
                    print("Erro na recuperacao da atividade !")
                    print(error as Any)
                }
            }
        }
        
        database.add(operation)
    }
    
    func deleteAtividade(atividade: Atividade){
        
        let database = container.publicCloudDatabase
        let recordID = atividade.recordID
        
        database.delete(withRecordID: recordID) { (deletedRecordID, error) in
            
            if error == nil {
                print("Deletado")
                
            } else {
                print("Nao deletou...")
                print(error as Any)
            }
        }
    }
}

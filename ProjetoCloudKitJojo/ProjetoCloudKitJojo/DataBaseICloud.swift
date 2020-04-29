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
        
    }
    
    func deleteAtividade(){
        
    }
    
    
}

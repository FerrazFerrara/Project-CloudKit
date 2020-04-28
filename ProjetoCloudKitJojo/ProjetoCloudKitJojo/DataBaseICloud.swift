//
//  DataBaseICloud.swift
//  ProjetoCloudKitJojo
//
//  Created by Jonatas Coutinho de Faria on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import CloudKit

class DataBaseICloud{
    
    static let shared = DataBaseICloud()
    
    let container = CKContainer(identifier: "iCloud.mini4.com.jojo.seila")
    
    //Initializer access level change now
    private init(){}
    
    
    // MARK: - CRUD USUÁRIO
    
    func createUser(){
        
    }
    
    func updateUser(){
        
    }
    
    func retrieveUser(){
        
    }
    
    func deleteUser(){
        
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

//
//  Usuario.swift
//  ProjetoCloudKitJojo
//
//  Created by Jonatas Coutinho de Faria on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Usuario{
    
    var recordID: CKRecord.ID?
    var idFamilia: String?
    var nome: String?
    var pontuacao: Int?
    var foto: UIImage?
    var conquista: [Bool]?
    var vitoria: Int?
    var derrota: Int?
    
    init(idFamilia: String, nome: String, pontuacao: Int, foto: UIImage?, conquista: [Bool], vitoria: Int, derrota: Int) {
//        self.recordID = CKRecord.ID(recordName: "08B8053A-C041-4CEF-B3B8-B6F07A184AD2")
        self.idFamilia = idFamilia
        self.pontuacao = pontuacao
        self.nome = nome
        self.foto = foto
        self.conquista = conquista
        self.vitoria = vitoria
        self.derrota = derrota
    }
    
    init(recordID: CKRecord.ID, idFamilia: String, nome: String, pontuacao: Int, foto: UIImage?, conquista: [Bool], vitoria: Int, derrota: Int) {
            self.recordID = recordID
            self.idFamilia = idFamilia
            self.pontuacao = pontuacao
            self.nome = nome
            self.foto = foto
            self.conquista = conquista
            self.vitoria = vitoria
            self.derrota = derrota
        }
    
    init(recordID: CKRecord.ID, idFamilia: NSString, nome: NSString, pontuacao: NSNumber, foto: CKAsset?, conquista: [NSNumber], vitoria: NSNumber, derrota: NSNumber) {
        self.recordID = recordID
        self.idFamilia = idFamilia as String
        setNome(nome: nome)
        setPontuacao(pontuacao: pontuacao)
        setFoto(foto: foto)
        setConquista(conquista: conquista)
        setDerrota(derrota: derrota)
        setVitoria(vitoria: vitoria)
    }
    
    init(){
//        self.recordID = CKRecord.ID(recordName: "08B8053A-C041-4CEF-B3B8-B6F07A184AD2")
    }

    
    private func setNome(nome: NSString){
        self.nome = nome as String
    }
    
    private func setPontuacao(pontuacao: NSNumber){
        self.pontuacao = pontuacao.intValue
    }
    
    private func setFoto(foto: CKAsset?){
        if foto != nil{
            if let data = NSData(contentsOf: (foto?.fileURL!)!) {
                self.foto = UIImage(data: data as Data)
            }else{
                //Foto padrao
                 self.foto = UIImage()
            }
        }
    }
    
    private func setConquista(conquista: [NSNumber]){
        var aux: [Bool] = []
        
        for i in conquista{
            aux.append(i.boolValue)
        }
        
        self.conquista = aux
    }
    
    private func setVitoria(vitoria: NSNumber){
        self.derrota = vitoria.intValue
    }
    
    private func setDerrota(derrota: NSNumber){
        self.vitoria = derrota.intValue
    }
}


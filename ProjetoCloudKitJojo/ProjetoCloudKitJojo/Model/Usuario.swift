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
    
    var recordID: CKRecord.ID
    var idFamilia: String?
    var nome: String?
    var pontuacao: Int?
    var foto: UIImage?
    var conquista: [Bool]?
    var vitoria: Int?
    var derrota: Int?
    
    init(recordID: CKRecord.ID, idFamilia: String, nome: String, pontuacao: Int, foto: UIImage, conquista: [Bool], vitoria: Int, derrota: Int) {
        
        self.recordID = recordID
        self.idFamilia = idFamilia
        self.pontuacao = pontuacao
        self.nome = nome
        self.foto = foto
        self.conquista = conquista
        self.vitoria = vitoria
        self.derrota = derrota
    }
    
    init(recordID: CKRecord.ID, idFamilia: String, nome: String, pontuacao: Int64, foto: CKAsset, conquista: [Int64], vitoria: Int64, derrota: Int64) {
        self.recordID = recordID
        setIdFamilia(idFamilia: idFamilia)
        setNome(nome: nome)
        setPontuacao(pontuacao: pontuacao)
        setFoto(foto: foto)
        setConquista(conquista: conquista)
        setDerrota(derrota: derrota)
        setVitoria(vitoria: vitoria)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setIdFamilia(idFamilia: String){
        self.idFamilia = String()
    }
    
    private func setNome(nome: String){
        self.nome = String()
    }
    
    private func setPontuacao(pontuacao: Int64){
        self.pontuacao = Int()
    }
    
    private func setFoto(foto: CKAsset){
        self.foto = UIImage()
    }
    
    private func setConquista(conquista: [Int64]){
        self.conquista = [Bool]()
    }
    
    private func setVitoria(vitoria: Int64){
        self.derrota = Int()
    }
    
    private func setDerrota(derrota: Int64){
        self.vitoria = Int()
    }
}

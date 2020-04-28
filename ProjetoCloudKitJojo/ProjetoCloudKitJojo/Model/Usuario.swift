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
    
    var idFamilia: String?
    var nome: String?
    var foto: UIImage?
    var conquista: Int?
    var vitoria: Int?
    var derrota: Int?
    
    init(idFamilia: String, nome: String, foto: UIImage, conquista: Int, vitoria: Int, derrota: Int) {
        self.idFamilia = idFamilia
        self.nome = nome
        self.foto = foto
        self.conquista = conquista
        self.vitoria = vitoria
        self.derrota = derrota
    }
    
    init(idFamilia: String, nome: String, foto: CKAsset, conquista: Int64, vitoria: Int64, derrota: Int64) {
        self.idFamilia = idFamilia
        self.nome = nome
        setFoto(foto: foto)
        setConquista(conquista: conquista)
        setDerrota(derrota: derrota)
        setVitoria(vitoria: vitoria)
    }
    
    private func setFoto(foto: CKAsset){
        self.foto = UIImage()
    }
    
    private func setConquista(conquista: Int64){
        self.conquista = Int()
    }
    
    private func setVitoria(vitoria: Int64){
        self.derrota = Int()
    }
    
    private func setDerrota(derrota: Int64){
        self.vitoria = Int()
    }
}

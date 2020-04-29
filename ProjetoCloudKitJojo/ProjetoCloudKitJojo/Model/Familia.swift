//
//  Familia.swift
//  ProjetoCloudKitJojo
//
//  Created by Jonatas Coutinho de Faria on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import CloudKit

class Familia{
    
    var recordID: CKRecord.ID
    var codigo: String?
    var nome: String?
    var usuarios: [Usuario]?
    var atividades: [Atividade]?
    var penalidade: String?
    var recompensa: String?
    var penalidadeFlag: Bool?
    var recompensaFlag: Bool?
    
    init(recordID: CKRecord.ID, codigo: String, nome: String, usuarios: [Usuario], atividades: [Atividade], penalidade: String, recompensa: String, penalidadeFlag: Bool, recompensaFlag: Bool) {
        self.recordID = recordID
        self.codigo = codigo
        self.nome = nome
        self.usuarios = usuarios
        self.atividades = atividades
        self.penalidade = penalidade
        self.recompensa = recompensa
        self.penalidadeFlag = penalidadeFlag
        self.recompensaFlag = recompensaFlag
    }
    
    init(recordID: CKRecord.ID, codigo: String, nome: String, usuarios: [Usuario], atividades: [Atividade], penalidade: String, recompensa: String, penalidadeFlag: Int64, recompensaFlag: Int64) {
        self.recordID = recordID
        setCodigo(codigo: codigo)
        setNome(nome: nome)
        setUsuarios(usuarios: usuarios)
        setAtividades(atividades: atividades)
        setpenalidade(penalidade: penalidade)
        setRecompensa(recompensa: recompensa)
        setPenalidadeFlag(penalidadeFlag: penalidadeFlag)
        setRecompensaFlag(recompensaFlag: recompensaFlag)
    }
    
    private func setCodigo(codigo: String){
        self.codigo = String()
    }
    
    private func setNome(nome: String){
        self.nome = String()
    }
    
    private func setUsuarios(usuarios: [Usuario]){
        self.usuarios = [Usuario]()
    }
    
    private func setAtividades(atividades: [Atividade]){
        self.atividades = [Atividade]()
    }
    
    private func setpenalidade(penalidade: String){
        self.penalidade = String()
    }
    
    private func setRecompensa(recompensa: String){
        self.recompensa = String()
    }
    
    private func setPenalidadeFlag(penalidadeFlag: Int64){
        self.penalidadeFlag = Bool()
    }
    
    private func setRecompensaFlag(recompensaFlag: Int64){
        self.recompensaFlag = Bool()
    }
}

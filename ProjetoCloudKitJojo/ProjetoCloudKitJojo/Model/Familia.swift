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
    var nome: String?
    var usuarios: [Usuario]?
    var atividades: [Atividade]?
    var penalidade: String?
    var recompensa: String?
    var penalidadeFlag: Bool?
    var recompensaFlag: Bool?
    
    init(recordID: CKRecord.ID){
        self.recordID = recordID
    }
    
    init(recordID: CKRecord.ID, nome: String, usuarios: [Usuario], atividades: [Atividade], penalidade: String?, recompensa: String?, penalidadeFlag: Bool, recompensaFlag: Bool) {
        self.recordID = recordID
        self.nome = nome
        self.usuarios = usuarios
        self.atividades = atividades
        self.penalidade = penalidade
        self.recompensa = recompensa
        self.penalidadeFlag = penalidadeFlag
        self.recompensaFlag = recompensaFlag
    }
    
    init(recordID: CKRecord.ID, nome: NSString, usuarios: [Usuario]?, atividades: [Atividade]?, penalidade: NSString?, recompensa: NSString?, penalidadeFlag: NSNumber, recompensaFlag: NSNumber) {
        self.recordID = recordID
        setNome(nome: nome)
        setpenalidade(penalidade: penalidade)
        setRecompensa(recompensa: recompensa)
        setPenalidadeFlag(penalidadeFlag: penalidadeFlag)
        setRecompensaFlag(recompensaFlag: recompensaFlag)
        self.usuarios = usuarios
        self.atividades = atividades
    }
    
    private func setNome(nome: NSString){
        self.nome = nome as String
    }
    
    private func setpenalidade(penalidade: NSString?){
        self.penalidade = penalidade as String?
    }
    
    private func setRecompensa(recompensa: NSString?){
        self.recompensa = recompensa as String?
    }
    
    private func setPenalidadeFlag(penalidadeFlag: NSNumber){
        self.penalidadeFlag = penalidadeFlag.boolValue
    }
    
    private func setRecompensaFlag(recompensaFlag: NSNumber){
        self.recompensaFlag = recompensaFlag.boolValue
    }
}

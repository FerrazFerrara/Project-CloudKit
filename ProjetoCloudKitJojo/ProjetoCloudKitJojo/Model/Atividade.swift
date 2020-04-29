//
//  Atividade.swift
//  ProjetoCloudKitJojo
//
//  Created by Jonatas Coutinho de Faria on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import CloudKit

class Atividade{
    
    var recordID: CKRecord.ID
    var dia: NSDate
    var etiqueta: String
    var horario: NSDate
    var nome: String
    var pontuacao: Int?
    var repeticao: Int?
    var realizou: Bool?
    
    var usuario: Usuario?
    var dataFeito: NSDate?
    
    init(recordID: CKRecord.ID, dia: NSDate, etiqueta: String, horario: NSDate, nome: String, pontuacao: Int, repeticao: Int, user: Usuario, dataFeito: NSDate, realizou: Bool) {
        self.recordID = recordID
        self.dia = dia
        self.etiqueta = etiqueta
        self.horario = horario
        self.nome = nome
        self.pontuacao = pontuacao
        self.repeticao = repeticao
        self.realizou = realizou
        self.dataFeito = dataFeito
        self.usuario = user
    }
    
    init(recordID: CKRecord.ID, dia: NSDate, etiqueta: String, horario: NSDate, nome: String, pontuacao: Int64, repeticao: Int64, user: Usuario, dataFeito: NSDate, realizou: Int64) {
        self.recordID = recordID
        self.dia = dia
        self.etiqueta = etiqueta
        self.horario = horario
        self.nome = nome
        self.realizou = true
        self.dataFeito = dataFeito
        self.usuario = user
        
        self.setRealizou(realizou: realizou)
        self.setPontuacao(pontuacao: pontuacao)
        self.setRepeticao(repeticao: repeticao)
    }
    
    private func setPontuacao(pontuacao: Int64){
        let pont = Int(pontuacao)
        self.pontuacao = pont
    }
    
    private func setRealizou(realizou: Int64){
        let realiz = realizou.convert64toBool()
        self.realizou = realiz
    }
    
    private func setRepeticao(repeticao: Int64){
        let repet = Int(repeticao)
        self.repeticao = repet
    }
}

extension Int64{
    public func convert64toBool() -> Bool{
        if self == 0{
            return false
        } else {
            return true
        }
    }
}

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
    var dia: NSDate
    var etiqueta: String
    var horario: NSDate
    var nome: String
    var pontuacao: Int
    var repeticao: Int
    var realizou: Bool
    
    var usuario: Usuario?
    var dataFeito: NSDate?
    
    init(dia: NSDate, etiqueta: String, horario: NSDate, nome: String, pontuacao: Int, repeticao: Int, user: Usuario, dataFeito: NSDate, realizou: Bool) {
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
    
    init(dia: NSDate, etiqueta: String, horario: NSDate, nome: String, pontuacao: Int64, repeticao: Int64, user: Usuario, dataFeito: NSDate, realizou: Int64) {
        self.dia = dia
        self.etiqueta = etiqueta
        self.horario = horario
        self.nome = nome
        self.realizou = true
        self.dataFeito = dataFeito
        self.usuario = user
        
        let pont = Int(pontuacao)
        let repet = Int(repeticao)
        let realiz = repeticao.convert64toBool()
        
        self.pontuacao = pont
        self.realizou = realiz
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

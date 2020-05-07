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

    var recordID: CKRecord.ID?
    var dia: String?
    var etiqueta: String?
    var horario: Date?
    var nome: String?
    var pontuacao: Int?
    var repeticao: Int?
    var realizou: Bool?
    var dataFeito: Date?
    var usuario: Usuario?
    var idFamilia: String?
    
    init(recordID: CKRecord.ID, idFamilia: String?, dia: String?, etiqueta: String, horario: Date, nome: String, pontuacao: Int, repeticao: Int, user: Usuario?, dataFeito: Date?, realizou: Bool) {
        self.idFamilia = idFamilia
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

    init(recordID: CKRecord.ID, idFamilia: String?, dia: NSString, etiqueta: NSString, horario: NSDate, nome: NSString, pontuacao: NSNumber, repeticao: NSNumber, usuario: Usuario?, dataFeito: NSDate?, realizou: NSNumber) {
        self.idFamilia = idFamilia
        self.recordID = recordID
        setDia(dia: dia)
        setEtiqueta(etiqueta: etiqueta)
        setHorario(horario: horario)
        setNome(nome: nome)
        setPontuacao(pontuacao: pontuacao)
        setRepeticao(repeticao: repeticao)
        setRealizou(realizou: realizou)
        setDataFeito(dataFeito: dataFeito)
        self.usuario = usuario
    }
    
    init(){
//        self.recordID = CKRecord.ID(recordName: "16DF130E-66AB-42B9-A48F-B5D1A24F05E4")
    }

    private func setDia(dia: NSString){
        self.dia = dia as String
    }
    
    private func setEtiqueta(etiqueta: NSString){
        self.etiqueta = etiqueta as String
    }
    
    private func setHorario(horario: NSDate){
        self.horario = horario as Date
    }
    
    private func setNome(nome: NSString){
        self.nome = nome as String
    }
    
    private func setRealizou(realizou: NSNumber){
        self.realizou = realizou.boolValue
    }
    
    private func setDataFeito(dataFeito: NSDate?){
        self.dataFeito = dataFeito as Date?
    }
    
    private func setPontuacao(pontuacao: NSNumber){
        self.pontuacao = pontuacao.intValue
    }

    private func setRepeticao(repeticao: NSNumber){
        self.repeticao = repeticao.intValue
    }
}

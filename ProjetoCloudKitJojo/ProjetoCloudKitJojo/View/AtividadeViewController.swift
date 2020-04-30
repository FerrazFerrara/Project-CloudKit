//
//  AtividadeViewController.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 30/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import UIKit

class AtividadeViewController: UIViewController{
    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var etiqueta: UITextField!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var pontuacao: UITextField!
    @IBOutlet weak var repeticao: UITextField!
    @IBOutlet weak var dataHora: UIDatePicker!
    @IBOutlet weak var apenasHora: UIDatePicker!
    
    let banco = DataBaseICloud.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func salvarBtn(_ sender: Any) {
        let dia = dataHora.date
        let hora = apenasHora.date
        
        guard let etiquetaCK = etiqueta.text else { return }
        guard let nomeCK = nome.text else { return }
        guard let pontuacaoCK = pontuacao.text else { return }
        guard let repeticaoCK = repeticao.text else { return }
        guard let usuarioCK = usuario.text else { return }
        
        let userIndex = Int(usuarioCK)
        let pont = Int(pontuacaoCK)
        let repet = Int(repeticaoCK)
        
        let user = banco.usuarios[userIndex!]
        
        banco.createAtividade(nome: nomeCK, pontuacao: pont!, dia: dia, horario: hora, repete: repet!, etiqueta: etiquetaCK, user: user)
        
    }
    
    @IBAction func buscarBtn(_ sender: Any) {
        banco.retrieveAtividade()
    }
    
    @IBAction func modificarBtn(_ sender: Any) {
//        guard let nomeCK = nome.text else { return }
//        banco.updateAtividade()
    }
    
    @IBAction func deletarBtn(_ sender: Any) {
//        let firstAtividade = banco.atividades.first!
//        banco.deleteUser(atividade: firstAtividade)
    }
}

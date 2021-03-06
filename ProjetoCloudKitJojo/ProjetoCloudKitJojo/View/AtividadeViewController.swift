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
    
    @IBOutlet weak var dia: UITextField!
    @IBOutlet weak var etiqueta: UITextField!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var pontuacao: UITextField!
    @IBOutlet weak var repeticao: UITextField!
    @IBOutlet weak var apenasHora: UIDatePicker!
    
    let banco = DataBaseICloud.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buscarBtn(_ sender: Any) {
        
    }
    
    @IBAction func adicionaTarefa(_ sender: Any) {
        guard let nomeA = nome.text else { return }
        guard let diaA = dia.text else { return }
        guard let etiquetaA = etiqueta.text else { return }
        guard let pontuacaoA = pontuacao.text else { return }
        guard let repeticaoA = repeticao.text else { return }
        
        guard let pont = Int(pontuacaoA) else { return }
        guard let repet = Int(repeticaoA) else { return }
        let data = apenasHora.date
        
        guard let familiaID = banco.familia?.recordID else { return }
        
        self.banco.retrieveFamilia(id: familiaID) { (familia) in
            let atividade = Atividade(idFamilia: familiaID.recordName, nome: nomeA, dia: diaA, etiqueta: etiquetaA, pontuacao: pont, repeticao: repet, horario: data)
            self.banco.createAtividade(atividade: atividade) { _ in }
        }
    }
}

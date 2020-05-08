//
//  ViewController.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 27/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nomeFamilia: UITextField!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let banco = DataBaseICloud.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func salvarBtn(_ sender: Any) {
        
        
//        let pontuaInt = Int(pontua)
//        let vitorInt = Int(vitor)
//        let derroInt = Int(derro)
//        var conquiBool = [true, false, true, true]
//        if conqui == "false"{
//            conquiBool = [false, true, false, false]
//        }
//
//        banco.createUser(idFamilia: idFam, nome: nom, pontuacao: pontuaInt!, conquista: conquiBool, vitoria: vitorInt!, derrota: derroInt!, foto: UIImage(named: "1")!)
//
//
        
    }
    
    @IBAction func criarFamilia(_ sender: Any) {
        guard let seuNome = nome.text else { return }
        guard let familiaNome = nomeFamilia.text else { return }
        
        banco.createFamilia(nome: familiaNome) { (familia) in
            let user = Usuario(idFamilia: familia.recordID.recordName, nome: seuNome, foto: UIImage(named: "1"))
            self.banco.createUser(usuario: user) { (user) in
                UserDefaults.standard.set(familia.recordID.recordName, forKey: "idFamilia")
                UserDefaults.standard.set(user.recordID?.recordName, forKey: "idUsuario")
            }
        }
    }
}


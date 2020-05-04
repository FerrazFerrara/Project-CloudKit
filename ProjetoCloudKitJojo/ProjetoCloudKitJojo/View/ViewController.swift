//
//  ViewController.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 27/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var idFamilia: UITextField!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var pontuacao: UITextField!
    @IBOutlet weak var conquista: UITextField!
    @IBOutlet weak var vitoria: UITextField!
    @IBOutlet weak var derrota: UITextField!
    
    let banco = DataBaseICloud.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func salvarBtn(_ sender: Any) {
        guard let idFam = idFamilia.text else{ return }
        guard let nom = nome.text else{ return }
        guard let pontua = pontuacao.text else{ return }
        guard let conqui = conquista.text else{ return }
        guard let vitor = vitoria.text else{ return }
        guard let derro = derrota.text else{ return }
        
        let pontuaInt = Int(pontua)
        let vitorInt = Int(vitor)
        let derroInt = Int(derro)
        var conquiBool = [true, false, true, true]
        if conqui == "false"{
            conquiBool = [false, true, false, false]
        }
        
        banco.createUser(idFamilia: idFam, nome: nom, pontuacao: pontuaInt!, conquista: conquiBool, vitoria: vitorInt!, derrota: derroInt!, foto: UIImage(named: "1")!)
    }
    
    @IBAction func buscarBtn(_ sender: Any) {
//        banco.retrieveUser(id: )
    }
    
    @IBAction func modificar(_ sender: Any) {
        guard let nom = nome.text else { return }
        
        banco.updateUser(novoNome: nom)
    }
    
    @IBAction func deletarBtn(_ sender: Any) {
        let firstUser = banco.usuarios.first!
        banco.deleteUser(usuario: firstUser)
    }
}


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
        guard let nom = idFamilia.text else{ return }
        guard let pontua = idFamilia.text else{ return }
        guard let conqui = idFamilia.text else{ return }
        guard let vitor = idFamilia.text else{ return }
        guard let derro = idFamilia.text else{ return }
        
        let pontuaInt = Int(pontua)
        let vitorInt = Int(vitor)
        let derroInt = Int(derro)
        var conquiBool = [true]
        if conqui == "false"{
            conquiBool = [false]
        }
        
        banco.createUser(idFamilia: idFam, nome: nom, pontuacao: pontuaInt!, conquista: conquiBool, vitoria: vitorInt!, derrota: derroInt!)
    }
    
    @IBAction func buscarBtn(_ sender: Any) {
        banco.retrieveUser()
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


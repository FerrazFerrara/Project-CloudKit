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
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.goToData), name: NSNotification.Name(rawValue: "didFinishUserDefaultObserver"), object: nil)
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
        
        activityIndicator.startAnimating()
        
        banco.createFamilia(nome: familiaNome, completion: { familia in
            let familiaID = familia.recordID.recordName
            self.banco.createUser(idFamilia: familiaID, nome: seuNome, pontuacao: 0, conquista: [false,false], vitoria: 0, derrota: 0, foto: UIImage(named: "1")!, completion: { user in
                self.banco.updateFamilia(newFamilia: self.banco.familia!, newUser: user, newAtividade: nil, newFeedInfo: nil)
                self.banco.createPrivateUsuario(idFamilia: familia.recordID.recordName, idUser: user.recordID!.recordName)
            })
        })
        
        activityIndicator.stopAnimating()
        performSegue(withIdentifier: "goToAtividades", sender: self)
    }
}


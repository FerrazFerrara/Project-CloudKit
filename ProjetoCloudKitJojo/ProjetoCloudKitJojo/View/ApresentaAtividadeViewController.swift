//
//  ApresentaAtividadeViewController.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 07/05/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import UIKit

class ApresentaAtividadeViewController: UIViewController{
    
    @IBOutlet weak var tableViewA: UITableView!
    
    var atividades = [Atividade]()
    
    override func viewDidLoad() {
        buscarDados()
        tableViewA.delegate = self
        tableViewA.dataSource = self
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        tableViewA.reloadData()
    }
    
    func buscarDados(){
        let banco = DataBaseICloud.shared
        banco.retrieveAtividade(idFamilia: banco.familia!.recordID) { (atividad) in
            self.atividades = atividad
            self.tableViewA.reloadData()
        }
    }
    
}

extension ApresentaAtividadeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return atividades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellA", for: indexPath) as! CustomCellAtividade
        cell.nome.text = atividades[indexPath.row].nome
        cell.pontos.text = "\(atividades[indexPath.row].pontuacao!)"
        cell.atividade = atividades[indexPath.row]
        
        return cell
    }
}

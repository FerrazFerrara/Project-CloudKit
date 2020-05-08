//
//  ApresentaUserViewController.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 07/05/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import UIKit

class ApresentaUserViewController: UIViewController{

    @IBOutlet weak var tabelViewU: UITableView!

    var usuarios = [Usuario]()

    override func viewDidLoad() {
        print("chegou aq")
        tabelViewU.delegate = self
        tabelViewU.dataSource = self
        
        let scene = UIApplication.shared.connectedScenes.first
        if let scene = (scene?.delegate as? SceneDelegate) {
            scene.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        buscarUsers()
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        tabelViewU.reloadData()
    }

//    func buscarUsers(){
//        let banco = DataBaseICloud.shared
//        banco.retrieveUser2(id: banco.familia!.recordID) { (users) in
//            self.usuarios = users
//            self.tabelViewU.reloadData()
//        }
//    }
}

extension ApresentaUserViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellU", for: indexPath) as! CustomCellUser
        cell.nome.text = usuarios[indexPath.row].nome
        cell.pontos.text = "\(usuarios[indexPath.row].pontuacao!)"

        return cell
    }
}

extension ApresentaUserViewController: UpdateDataDelegate{

    func updateTableView() {
        self.tabelViewU.reloadData()
    }
}

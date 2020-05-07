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
//        tabelViewU.delegate = self
//        tabelViewU.dataSource = self
    }
}

//extension ApresentaUserViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let banco = DataBaseICloud.shared
//        var userCount = 0
//        banco.retrieveUser2(id: banco.familia!.recordID) { (users) in
//            
//        }
//        return userCount
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}

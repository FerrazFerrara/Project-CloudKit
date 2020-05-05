//
//  FamiliaViewController.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 30/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class FamiliaViewController: UIViewController{
    
    @IBOutlet weak var nomeFamilia: UITextField!
    @IBOutlet weak var nomeUsuario: UITextField!
    
    
    let banco = DataBaseICloud.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func entrarFamilia(_ sender: Any) {
        guard let idFamilia = nomeFamilia.text else { return }
        let recordFamilia = CKRecord.ID(recordName: idFamilia)
        banco.retrieveFamilia(id: recordFamilia)
    }
    
}

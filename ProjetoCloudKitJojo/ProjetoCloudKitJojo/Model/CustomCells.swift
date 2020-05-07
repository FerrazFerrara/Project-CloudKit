//
//  CustomCells.swift
//  ProjetoCloudKitJojo
//
//  Created by Ferraz on 07/05/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import UIKit

class CustomCellUser: UITableViewCell{
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var pontos: UILabel!
}

class CustomCellAtividade: UITableViewCell{
    var atividade: Atividade?
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var pontos: UILabel!
    
    @IBAction func complete(_ sender: Any) {
        DataBaseICloud.shared.atividadeRealizada(atividade: atividade!)
    }
}

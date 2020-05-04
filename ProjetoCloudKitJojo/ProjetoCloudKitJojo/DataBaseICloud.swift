//
//  DataBaseICloud.swift
//  ProjetoCloudKitJojo
//
//  Created by Jonatas Coutinho de Faria on 28/04/20.
//  Copyright © 2020 Ferraz. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class DataBaseICloud{
    
    // MARK: - Atributos
    
    /// instancia do banco (Singleton)
    static let shared = DataBaseICloud()
    
    /// container no iCloud Dashboard
    let container = CKContainer(identifier: "iCloud.mini4.com.jojo.seila")
    
    /// array de usuarios buscados pelo banco
    var usuarios = [Usuario]()
    /// array de atividades buscadas pelo banco
    var atividades = [Atividade]()
    /// familia buscada pelo banco
    var familia: Familia?
    
    //Initializer access level change now
    private init(){}
    
    // MARK: - CRUD USUÁRIO
    
    /**
     Cria usuario e salva no iCloud
     
     - Parameters:
     - idFamilia: identificador da familia no usuario
     - nome: nome do usuario
     - pontuacao: pontuacao inicial do usuario
     - conquista: array indicando quais conquistas ja foram desbloquadas pelo usuario
     - vitoria: quantidade de vitorias do jogador
     - derrota: quantidade de derrotas do jogador
     - foto: foto de perfil do usuario
     */
    func createUser(idFamilia: String, nome: String, pontuacao: Int, conquista: [Bool], vitoria: Int, derrota: Int, foto: UIImage){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        /// record criado para ser usado no tabela Usuario
        let record = CKRecord(recordType: "Usuario")
        
        // transformando a UIImage para CKAsset
        guard let asset = transformImage(foto: foto) else { return }
        
        // settando os valores do usuario no record
        record.setValue(idFamilia, forKey: "idFamilia")
        record.setValue(nome, forKey: "nome")
        record.setValue(pontuacao, forKey: "pontuacao")
        record.setValue(conquista, forKey: "conquista")
        record.setValue(vitoria, forKey: "vitoria")
        record.setValue(derrota, forKey: "derrota")
        record.setValue(asset, forKey: "foto")
        
        // salvando o usuario no banco
        database.save(record) { (recordSave, error) in
            if error == nil{
                // usuario salvo
                print("Yaaay salvou um usuario")
            } else {
                // usuario nao salvo
                print("usuario nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    /**
     Atualiza o primeiro usuario do array e salva no iCloud
     
     - Parameters:
     - novoNome: nome que será sobrescrito no nome atual do usuario
     */
    func updateUser(novoNome: String){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        /// identificador do primeiro usuario do array de usuarios
        let recordUserIDFirst = self.usuarios.first!.recordID
        
        // busca o dado compativel com o id
        database.fetch(withRecordID: recordUserIDFirst) { (record, error) in
            if error == nil{
                // id encontrado
                // armazena o novo valor
                record?.setValue(novoNome, forKey: "nome")
                
                // salva o dado novamente
                database.save(record!) { (newRecord, error) in
                    if error == nil{
                        print("Deu update tranquilo aq")
                    } else {
                        print("Deu ruim no update aq bro")
                    }
                }
            } else {
                // id nao encontrado
                print("nao rolou de buscar os dados")
            }
        }
    }
    
    /**
     Busca os dados da tabela de usuarios do banco
     */
    
    func retrieveUser2(id: CKRecord.ID, completion: @escaping ([Usuario]) -> Void){
        
        var usuarios: [Usuario] = []
        
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // fazendo a query do banco na tabela de usuario
        let predicate = NSPredicate(format: "idFamilia = %@", id)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        // determina por qual atributo e qual forma sera organizado os dados buscados
        // no caso, em ordem alfabetica e ascendente
        query.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        // operacao para ser realizada na query criada
        let operation = CKQueryOperation(query: query)
        
        // operacao de buscar os dados
        operation.recordFetchedBlock = { record in
            // instanciando um usuario a partir dos dados buscados do banco
            let user = Usuario(recordID: record.recordID, idFamilia: record["idFamilia"] as! NSString, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, foto: record["foto"] as? CKAsset, conquista: record["conquista"] as! [NSNumber], vitoria: record["vitoria"] as! NSNumber, derrota: record["derrota"] as! NSNumber)
            // adicionando os usuarios do banco no array
            usuarios.append(user)
        }
        
        // para realizar acoes após a busca de dados no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error as Any)
                }else{
                    print("deu bom")
                }
            }
            
            completion(usuarios)
        }
        
        // realizar operacao
        database.add(operation)
        
    }
    func retrieveUser(id: CKRecord.ID){
        
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // fazendo a query do banco na tabela de usuario
        let predicate = NSPredicate(format: "idFamilia = %@", id)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        // determina por qual atributo e qual forma sera organizado os dados buscados
        // no caso, em ordem alfabetica e ascendente
        query.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        // operacao para ser realizada na query criada
        let operation = CKQueryOperation(query: query)
        
        // zerar o array de usuarios com os dados antigos
        usuarios.removeAll()
        
        // operacao de buscar os dados
        operation.recordFetchedBlock = { record in
            // instanciando um usuario a partir dos dados buscados do banco
            let user = Usuario(recordID: record.recordID, idFamilia: record["idFamilia"] as! NSString, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, foto: record["foto"] as? CKAsset, conquista: record["conquista"] as! [NSNumber], vitoria: record["vitoria"] as! NSNumber, derrota: record["derrota"] as! NSNumber)
            // adicionando os usuarios do banco no array
            self.usuarios.append(user)
        }
        
        // para realizar acoes após a busca de dados no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                print("=========================")
                print(self.usuarios)
                if error != nil{
                    print(error as Any)
                }
            }
        }
        
        // realizar operacao
        database.add(operation)
    }
    
    /**
     exclui um usuario do banco
     
     - Parameters:
     - usuario: Usuario a ser deletado
     */
    func deleteUser(usuario: Usuario){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        // pega o id do usuario
        let recordID = usuario.recordID
        
        // deleta o usuario do banco a partir do id dele
        database.delete(withRecordID: recordID) { (deletedRecordID, error) in
            if error == nil {
                // deletado com sucesso
                print("Deletado")
            } else {
                // nao conseguiu deletar
                print("Nao deletou...")
                print(error as Any)
            }
        }
    }
    
    
    // MARK: - CRUD FAMÍLIA
    
    func createFamilia(){
        
    }
    
    func updateFamilia(){
        
    }
    
    
    
    func retrieveFamilia(id: CKRecord.ID){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // fazendo query da tabela de familia buscando somente a familia com ID do parametro
        let predicate = NSPredicate(format: "recordID = %@", id)
        let query = CKQuery(recordType: "Familia", predicate: predicate)
        
        // determina qual forma os dados serao organizados na busca
        // no caso, sera organizado de forma ascendente e data de criacao da familia
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // operacao da query criada
        let operation = CKQueryOperation(query: query)
        
        // busca os dados da tabela de Atividades
        operation.recordFetchedBlock = { record in
            
            
            
            // busca os usuarios da familia e atribui ao array da classe
            self.retrieveUser(id: record.recordID)
            
            //array de referencias das atividades
            let activitiesReferences = record["atividades"] as! [CKRecord.Reference]
            
            for record in activitiesReferences{
                
                // auxiliar para o usuario de cada atividade
                var user = Usuario()
                
                // busca da referencia das atividades
                database.fetch(withRecordID: CKRecord.ID(recordName: record.recordID.recordName)) { (recordActivity, error) in
                    
                    let userReference = recordActivity!["usuario"] as! CKRecord.Reference
                    
                    //busca da referencia do usuario atrelado à atividade
                    database.fetch(withRecordID: CKRecord.ID(recordName: userReference.recordID.recordName)) { (recordUser, error) in
                        
                        user = Usuario(recordID: recordUser!.recordID, idFamilia: recordUser!["idFamilia"] as! NSString, nome: recordUser!["nome"] as! NSString, pontuacao: recordUser!["pontuacao"] as! NSNumber, foto: recordUser!["foto"] as? CKAsset, conquista: recordUser!["conquista"] as! [NSNumber], vitoria: recordUser!["vitoria"] as! NSNumber, derrota: recordUser!["derrota"] as! NSNumber)
                    }
                    
                    // instancia a atividade buscada
                    let activity = Atividade(recordID: recordActivity!.recordID, dia: recordActivity!["dia"] as! NSDate, etiqueta: recordActivity!["etiqueta"] as! NSString, horario: recordActivity!["horario"] as! NSDate, nome: recordActivity!["nome"] as! NSString, pontuacao: recordActivity!["pontuacao"] as! NSNumber, repeticao: recordActivity!["repeticao"] as! NSNumber, usuario: user, dataFeito: recordActivity!["dataFeito"] as? NSDate, realizou: recordActivity!["realizou"] as! NSNumber)
                    
                    // adiciona a atividade ao array de atividades
                    self.atividades.append(activity)
                }
            }
            
            // instancia a familia
            self.familia = Familia(recordID: record.recordID, nome: record["nome"] as! NSString, usuarios: self.usuarios, atividades: self.atividades, penalidade: record["penalidade"] as! NSString, recompensa: record["recompensa"] as! NSString, penalidadeFlag: record["penalidadeFlag"] as! NSNumber, recompensaFlag: record["recompensaFlag"] as! NSNumber, feed: record["feed"] as! [NSString])
        }
        
        // para realizar acoes apos a busca da familia no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error == nil {
                    // familia recuperada
                    print("Familia recuperada")
                    
                } else {
                    // familia nao recuperada
                    print("Erro na recuperacao da Familia!")
                    print(error as Any)
                }
            }
        }
        
        // realiza operacao
        database.add(operation)
    }
    
    func deleteFamilia(){
        
    }
    
    
    // MARK: - CRUD ATIVIDADE
    
    /**
     Cria atividade e salva no iCloud
     
     - Parameters:
     - nome: nome da atividade
     - pontuacao: pontuacao por realizar a atividade
     - dia: dia da semana que repete a atividade
     - horario: horario da atividade
     - repete: index de quantas vezes a atividade repete
     - etiqueta: etiqueta que identifica de onde a atividade é
     - user: usuario que realizou a atividade
     */
    func createAtividade(nome: String, pontuacao: Int, dia: Date, horario: Date, repete: Int, etiqueta: String, user: Usuario){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        
        // record usado na tabela de Atividade
        let record = CKRecord(recordType: "Atividade")
        
        // setta o usuario como uma referencia a tabela de usuarios na tabela de atividades
        let reference = CKRecord.Reference(recordID: user.recordID, action: CKRecord_Reference_Action.none)
        
        // settando os valores da atividade no record
        record.setValue(nome, forKey: "nome")
        record.setValue(pontuacao, forKey: "pontuacao")
        record.setValue(dia, forKey: "dia")
        record.setValue(horario, forKey: "horario")
        record.setValue(repete, forKey: "repeticao")
        record.setValue(etiqueta, forKey: "etiqueta")
        record.setValue(false, forKey: "realizou")
        //        record.setValue(, forKey: "dataFeito")
        record.setValue(reference, forKey: "usuario")
        
        // salva o record no banco
        database.save(record) { (recordSave, error) in
            if error == nil{
                // salvos com sucesso
                print("Yaaay salvou uma atividade")
            } else {
                // nao salvos
                print("Atividade nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    /**
     Altera o nome de uma atividade ja existente
     
     - Parameters:
     - nome: novo nome para atividade
     */
    func updateAtividade(novoNome: String){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // pega o recordID da primeira atividade do array de atividades
        let recordActivityIDFirst = self.atividades.first!.recordID
        
        // busca pela atividade pelo id
        database.fetch(withRecordID: recordActivityIDFirst) { (record, error) in
            if error == nil{
                // altera o valor do nome da atividade pelo nome novo
                record?.setValue(novoNome, forKey: "nome")
                
                // salva o record com a alteracao feita
                database.save(record!) { (newRecord, error) in
                    if error == nil{
                        // salvo
                        print("Deu update tranquilo aq")
                    } else {
                        // nao salvo
                        print("Deu ruim no update aq bro")
                    }
                }
            } else {
                // nao encontrou a atividade
                print("nao rolou de buscar os dados")
            }
        }
    }
    
    /**
     Busca as atividades do iCloud
     */
    func retrieveAtividade(){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // fazendo query da tabela de atividades
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Atividade", predicate: predicate)
        
        // determina qual forma os dados serao organizados na busca
        // no caso, sera organizado de forma ascendente e pela pontuacao da atividade
        query.sortDescriptors = [NSSortDescriptor(key: "pontuacao", ascending: true)]
        
        // operacao da query criada
        let operation = CKQueryOperation(query: query)
        
        // zera o array de atividades para popular com atividades novas do banco
        atividades.removeAll()
        
        /// usuario que esta atrelado a atividade
        var user = Usuario()
        
        // busca os dados da tabela de Atividades
        operation.recordFetchedBlock = { record in
            
            // busca a referencia do usuario na tabela de Atividade
            let userReference = record["usuario"] as! CKRecord.Reference
            
            // busca pela referencia do usuario na tabela de usuario
            database.fetch(withRecordID: CKRecord.ID(recordName: userReference.recordID.recordName)) { (recordUser, error) in
                // instancia o usuario a partir dos valores do usuario da tabela de atividades
                user = Usuario(recordID: recordUser!.recordID, idFamilia: recordUser!["idFamilia"] as! NSString, nome: recordUser!["nome"] as! NSString, pontuacao: recordUser!["pontuacao"] as! NSNumber, foto: recordUser!["foto"] as? CKAsset, conquista: recordUser!["conquista"] as! [NSNumber], vitoria: recordUser!["vitoria"] as! NSNumber, derrota: recordUser!["derrota"] as! NSNumber)
                
                // instancia a atividade buscada
                let activity = Atividade(recordID: record.recordID, dia: record["dia"] as! NSDate, etiqueta: record["etiqueta"] as! NSString, horario: record["horario"] as! NSDate, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, repeticao: record["repeticao"] as! NSNumber, usuario: user, dataFeito: record["dataFeito"] as? NSDate, realizou: record["realizou"] as! NSNumber)
                
                // adiciona a atividade ao array de atividadess
                self.atividades.append(activity)
            }
        }
        
        // para realizar acoes apos a busca de atividades no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error == nil {
                    // atividades recuperadas
                    print("Atividade recuperada")
                } else {
                    // atividades nao recuperadas
                    print("Erro na recuperacao da atividade !")
                    print(error as Any)
                }
            }
        }
        
        // realiza operacao
        database.add(operation)
    }
    
    /**
     Deleta atividade no iCloud
     
     - Parameters:
     - atividade: atividade que sera deletada do banco
     */
    func deleteAtividade(atividade: Atividade){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        // id da atividade no banco
        let recordID = atividade.recordID
        
        // deleta a atividade no banco a partir do ID dela
        database.delete(withRecordID: recordID) { (deletedRecordID, error) in
            if error == nil {
                // deletado
                print("Deletado")
            } else {
                // nao deletado
                print("Nao deletou...")
                print(error as Any)
            }
        }
    }
    
    // MARK: - Funções auxiliares para o banco
    
    /**
     Transforma uma UIImage em CKAsset para adicionar ao banco
     
     - Parameters:
     - foto: foto que sera adicionada ao iCloud
     
     - Returns: retorna CKAsset em caso de sucesso ou nil em caso de fracasso no cast
     */
    private func transformImage(foto: UIImage) -> CKAsset?{
        // transforma a UIImage em PNG
        let data = foto.pngData();
        // busca a url do diretorio temporario do iPhone
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            // adiciona a imagem png para a url
            try data!.write(to: url!)
            // cria o CKAsset a partir do png encontrado na url
            let asset = CKAsset(fileURL: url!)
            return asset
        } catch let e as NSError {
            // erro ao adicionar a imagem a url(provavel erro)
            print("Error! \(e)");
            return nil
        }
    }
}

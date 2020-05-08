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
    private let container = CKContainer(identifier: "iCloud.mini4.com.jojo.seila")
    
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
    func createUser(idFamilia: String, nome: String, pontuacao: Int, conquista: [Bool], vitoria: Int, derrota: Int, foto: UIImage, completion: @escaping (Usuario) -> Void){
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
//                let user = Usuario(idFamilia: idFamilia, nome: nome, pontuacao: pontuacao, foto: foto, conquista: conquista, vitoria: vitoria, derrota: derrota)
                let user = Usuario(recordID: record.recordID, idFamilia: idFamilia, nome: nome, pontuacao: pontuacao, foto: foto, conquista: conquista, vitoria: vitoria, derrota: derrota)
                self.usuarios.append(user)
                completion(user)
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
    func updateUser(user: Usuario){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        /// identificador do primeiro usuario do array de usuarios
        guard let userRecord = user.recordID else { return }
        guard let userFoto = user.foto else { return }
        guard let asset = transformImage(foto: userFoto) else { return }
        
        // busca o dado compativel com o id
        database.fetch(withRecordID: userRecord) { (record, error) in
            if error == nil{
                // id encontrado
                // armazena o novo valor
                record?.setValue(user.idFamilia, forKey: "idFamilia")
                record?.setValue(user.nome, forKey: "nome")
                record?.setValue(user.pontuacao, forKey: "pontuacao")
                record?.setValue(user.conquista, forKey: "conquista")
                record?.setValue(user.vitoria, forKey: "vitoria")
                record?.setValue(user.derrota, forKey: "derrota")
                record?.setValue(asset, forKey: "foto")
                
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
    
    private func addPontosUser(user: Usuario){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        /// identificador do primeiro usuario do array de usuarios
        guard let userID = user.recordID else { return }
        
        // busca o dado compativel com o id
        database.fetch(withRecordID: userID) { (record, error) in
            if error == nil{
                // id encontrado
                // armazena o novo valor
                record?.setValue(user.pontuacao, forKey: "pontuacao")
                
                // salva o dado novamente
                database.save(record!) { (newRecord, error) in
                    if error == nil{
                        print("Adicionou pontos pro usuario")
                    } else {
                        print("Deu ruim pra add ponto aq")
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
        let predicate = NSPredicate(format: "idFamilia = %@", id.recordName)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        // determina por qual atributo e qual forma sera organizado os dados buscados
        // no caso, em ordem alfabetica e ascendente
        query.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        // operacao para ser realizada na query criada
        let operation = CKQueryOperation(query: query)
        
        // operacao de buscar os dados
        operation.recordFetchedBlock = { record in
            // instanciando um usuario a partir dos dados buscados do banco
            let user = Usuario(recordID: record.recordID, idFamilia: id.recordName as NSString, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, foto: record["foto"] as? CKAsset, conquista: record["conquista"] as! [NSNumber], vitoria: record["vitoria"] as! NSNumber, derrota: record["derrota"] as! NSNumber)
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
                    self.usuarios = usuarios
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
        let predicate = NSPredicate(format: "idFamilia = %@", id.recordName)
//        let predicate = NSPredicate(value: true)
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
            let user = Usuario(recordID: record.recordID, idFamilia: self.familia!.recordID.recordName as NSString, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, foto: record["foto"] as? CKAsset, conquista: record["conquista"] as! [NSNumber], vitoria: record["vitoria"] as! NSNumber, derrota: record["derrota"] as! NSNumber)
            // adicionando os usuarios do banco no array
            self.usuarios.append(user)
        }
        
        // para realizar acoes após a busca de dados no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                print("=========================")
                for user in self.usuarios{
                    print(user.nome as Any)
                }
//                print(self.usuarios)
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
        let recordID = usuario.recordID!
        
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
    
    func createFamilia(nome: String, completion: @escaping (Familia) -> Void){
        
        /// acesso ao container public do banco
        let database = container.publicCloudDatabase
        /// record criado para ser usado na tabela Familia
        let record = CKRecord(recordType: "Familia")
        
        // buscando o usuario que ira fazer parte ad familia
        //        let recordUser = CKRecord(recordType: "Usuario", recordID: usuario.recordID)
        // buscando o array de usuarios da familia
        //        guard var usuariosFamilia = record["usuarios"] as? [CKRecord.Reference] else {
        //            print("erro ao buscar usuarios da familia")
        //            return
        //        }
        // criando uma referencia a partir do record do usuario
        //        let reference = CKRecord.Reference(record: recordUser, action: CKRecord_Reference_Action.none)
        //        // verifica se no array de usuarios da familia ja nao existe o usuario atual
        //        if !usuariosFamilia.contains(reference){
        //            // adiciona o usuario atual ao array de referencias da familia
        //            usuariosFamilia.append(reference)
        //        }
        
        // settando os valores da familia no record
        record.setValue(nome, forKey: "nome")
        record.setValue(false, forKey: "penalidadeFlag")
        record.setValue(false, forKey: "recompensaFlag")
        record.setValue([], forKey: "atividades")
        record.setValue([], forKey: "usuarios")
        record.setValue("", forKey: "recompensa")
        record.setValue("", forKey: "penalidade")
//        record.setValue(usuariosFamilia, forKey: "usuarios")
        
        
        // salva os dados do record na tabela de Familia
        database.save(record) { (recordSave, error) in
            if error == nil{
                // deu certo salvar a familia
                print("Salvou uma familia")
                self.familia = Familia(recordID: recordSave!.recordID, nome: nome, usuarios: [], atividades: [], penalidade: "", recompensa: "", penalidadeFlag: false, recompensaFlag: false)
                completion(self.familia!)
            } else {
                // deu errado
                print("Erro ao criar familia: \(error as Any)")
            }
        }
    }
    
    func updateFamilia(newFamilia: Familia, newUser: Usuario?, newAtividade: Atividade?){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // id da familia
        let idFamilia = self.familia?.recordID
        
        // busca da familia pelo record id
        database.fetch(withRecordID: idFamilia!) { (record, error) in
            if error == nil{
                // encontrou a familia
                // altera os valores da familia
                record?.setValue(newFamilia.penalidade, forKey: "penalidade")
                record?.setValue(newFamilia.penalidadeFlag, forKey: "penalidadeFlag")
                record?.setValue(newFamilia.recompensaFlag, forKey: "recompensaFlag")
                record?.setValue(newFamilia.recompensa, forKey: "recompensa")
                
                // caso tenha um usuario novo, adiciona ele ao array
                if let usuario = newUser{
                    // busca o usuario novo
                    let recordUser = CKRecord(recordType: "Usuario", recordID: usuario.recordID!)
                    // adiciona o usuario ao array de usuarios
                    let arrayUser = self.addElementoArrayReferencia(elemento: recordUser, record: record!, recordType: "usuarios")
                    // adiciona a lista de usuarios como novo valor na familia
                    record?.setValue(arrayUser, forKey: "usuarios")
                }
                
                // caso tenha uma atividade nova, adiciona ela ao array
                if let atividade = newAtividade{
                    // busca atividade nova
                    let recordAtividade = CKRecord(recordType: "Atividade", recordID: atividade.recordID!)
                    // 
                    let arrayAtividades = self.addElementoArrayReferencia(elemento: recordAtividade, record: record!, recordType: "atividades")
                    record?.setValue(arrayAtividades, forKey: "atividades")
                }
                
                database.save(record!) { (recordSave, error) in
                    if error == nil{
                        // salvo
                        print("Deu update tranquilo aq")
                    } else {
                        // nao salvo
                        print("Deu ruim no update aq bro")
                    }
                }
            } else {
                // nao encontrou a familia
                print("error ao buscar familia")
                print(error as Any)
            }
        }
    }
    
    func retrieveFamilia(id: CKRecord.ID, completion: @escaping (Familia) -> Void){
        self.familia = nil
        
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
            
            self.retrieveUser2(id: record.recordID, completion:  { users in
                self.retrieveAtividade(idFamilia: record.recordID, completion: { activities in
                    
                    // instancia a familia
                    self.familia = Familia(recordID: record.recordID, nome: record["nome"] as! NSString, usuarios: self.usuarios, atividades: self.atividades, penalidade: (record["penalidade"] as? NSString)!, recompensa: (record["recompensa"] as? NSString)!, penalidadeFlag: record["penalidadeFlag"] as! NSNumber, recompensaFlag: record["recompensaFlag"] as! NSNumber)
                })
            })
        }
        
        // para realizar acoes apos a busca da familia no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error == nil {
                    // familia recuperada
                    if self.familia == nil{
                        print("nenhuma familia encontrada")
                    } else {
                        print("Familia recuperada")
                        completion(self.familia!)
                    }
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
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        // id da familia no banco
        let idFamilia = self.familia?.recordID
        
        // deletando familia
        database.delete(withRecordID: idFamilia!) { (deletedRecordID, error) in
            if error == nil{
                // familia deletada
                print("familia deletada :(")
            } else {
                // erro ao deletar
                print("Nao conseuimos deletar meu mestre")
                print(error as Any)
            }
        }
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
    func createAtividade(nome: String, pontuacao: Int, dia: String?, horario: Date, repete: Int, etiqueta: String, completion: @escaping (Atividade) -> Void){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        
        // record usado na tabela de Atividade
        let record = CKRecord(recordType: "Atividade")
        
        let idFamilia = familia!.recordID.recordName
        
        // setta o usuario como uma referencia a tabela de usuarios na tabela de atividades
//        let reference = CKRecord.Reference(recordID: user.recordID!, action: CKRecord_Reference_Action.none)
        
        // settando os valores da atividade no record
        record.setValue(nome, forKey: "nome")
        record.setValue(pontuacao, forKey: "pontuacao")
        if let diaA = dia{
           record.setValue(diaA, forKey: "dia")
        }
        record.setValue(idFamilia, forKey: "idFamilia")
        record.setValue(horario, forKey: "horario")
        record.setValue(repete, forKey: "repeticao")
        record.setValue(etiqueta, forKey: "etiqueta")
        record.setValue(false, forKey: "realizou")
        //        record.setValue(, forKey: "dataFeito")
//        record.setValue(reference, forKey: "usuario")
        
        // salva o record no banco
        database.save(record) { (recordSave, error) in
            if error == nil{
                // salvos com sucesso
                print("Yaaay salvou uma atividade")
                let atividade = Atividade(recordID: recordSave!.recordID, idFamilia: idFamilia, dia: dia, etiqueta: etiqueta, horario: horario, nome: nome, pontuacao: pontuacao, repeticao: repete, user: nil, dataFeito: nil, realizou: false)
                completion(atividade)
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
    func updateAtividade(atividade: Atividade){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // pega o recordID da primeira atividade do array de atividades
        guard let atividadeID = atividade.recordID else { return }
        
        // busca pela atividade pelo id
        database.fetch(withRecordID: atividadeID) { (record, error) in
            if error == nil{
                // altera o valor do nome da atividade pelo nome novo
                record?.setValue(atividade.nome, forKey: "nome")
                record?.setValue(atividade.pontuacao, forKey: "pontuacao")
                if let diaA = atividade.dia{
                   record?.setValue(diaA, forKey: "dia")
                }
                record?.setValue(atividade.horario, forKey: "horario")
                record?.setValue(atividade.repeticao, forKey: "repeticao")
                record?.setValue(atividade.etiqueta, forKey: "etiqueta")
                
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
    
    func atividadeRealizada(atividade: Atividade){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // pega o recordID da primeira atividade do array de atividades
        guard let atividadeID = atividade.recordID else { return }
        guard let user = self.actualUser() else { return }
        guard let userID = user.recordID else { return }
        
        // setta o usuario como uma referencia a tabela de usuarios na tabela de atividades
        let reference = CKRecord.Reference(recordID: userID, action: CKRecord_Reference_Action.none)
        
        let currentDateTime = Date()
        
        // busca pela atividade pelo id
        database.fetch(withRecordID: atividadeID) { (record, error) in
            if error == nil{
                // altera o valor do nome da atividade pelo nome novo
                record?.setValue(currentDateTime, forKey: "dataFeito")
                record?.setValue(true, forKey: "realizada")
                record?.setValue(reference, forKey: "usuario")
                
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
        
        user.pontuacao! += atividade.pontuacao!
        
        self.addPontosUser(user: user)
    }
    
    /**
     Busca as atividades do iCloud
     */
    func retrieveAtividade(idFamilia: CKRecord.ID, completion: @escaping ([Atividade]) -> Void){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // fazendo query da tabela de atividades
        let predicate = NSPredicate(format: "idFamilia = %@", idFamilia.recordName)
        let query = CKQuery(recordType: "Atividade", predicate: predicate)
        
        // determina qual forma os dados serao organizados na busca
        // no caso, sera organizado de forma ascendente e pela pontuacao da atividade
        query.sortDescriptors = [NSSortDescriptor(key: "pontuacao", ascending: true)]
        
        // operacao da query criada
        let operation = CKQueryOperation(query: query)
        
        // zera o array de atividades para popular com atividades novas do banco
//        atividades.removeAll()
        
        var atividadesFamilia = [Atividade]()
        
        // busca os dados da tabela de Atividades
        operation.recordFetchedBlock = { record in
            
            var activity = Atividade()
            
            // busca a referencia do usuario na tabela de Atividade
            if let userReference = record["usuario"] as? CKRecord.Reference{
                // busca pela referencia do usuario na tabela de usuario
                database.fetch(withRecordID: CKRecord.ID(recordName: (userReference.recordID.recordName))) { (recordUser, error) in
                    // instancia o usuario a partir dos valores do usuario da tabela de atividades
                     let user = Usuario(recordID: recordUser!.recordID, idFamilia: self.familia!.recordID.recordName as NSString, nome: recordUser!["nome"] as! NSString, pontuacao: recordUser!["pontuacao"] as! NSNumber, foto: recordUser!["foto"] as? CKAsset, conquista: recordUser!["conquista"] as! [NSNumber], vitoria: recordUser!["vitoria"] as! NSNumber, derrota: recordUser!["derrota"] as! NSNumber)
                    
                    // instancia a atividade buscada
                    activity = Atividade(recordID: record.recordID, idFamilia: record["idFamilia"], dia: record["dia"] as! NSString, etiqueta: record["etiqueta"] as! NSString, horario: record["horario"] as! NSDate, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, repeticao: record["repeticao"] as! NSNumber, usuario: user, dataFeito: record["dataFeito"] as? NSDate, realizou: true)
                }
            } else {
                activity = Atividade(recordID: record.recordID, idFamilia: record["idFamilia"], dia: record["dia"] as! NSString, etiqueta: record["etiqueta"] as! NSString, horario: record["horario"] as! NSDate, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, repeticao: record["repeticao"] as! NSNumber, usuario: nil, dataFeito: nil, realizou: false)
            }
            // adiciona a atividade ao array de atividadess
            atividadesFamilia.append(activity)
        }
        
        // para realizar acoes apos a busca de atividades no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error == nil {
                    // atividades recuperadas
                    print("Atividade recuperada")
                    completion(atividadesFamilia)
                    self.atividades = atividadesFamilia
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


//        operation.recordFetchedBlock = { record in
//            // instanciando um usuario a partir dos dados buscados do banco
//            let user = Usuario(recordID: record.recordID, idFamilia: self.familia!.recordID.recordName as NSString, nome: record["nome"] as! NSString, pontuacao: record["pontuacao"] as! NSNumber, foto: record["foto"] as? CKAsset, conquista: record["conquista"] as! [NSNumber], vitoria: record["vitoria"] as! NSNumber, derrota: record["derrota"] as! NSNumber)
//            // adicionando os usuarios do banco no array
//            usuarios.append(user)
//        }
//
//        // para realizar acoes após a busca de dados no banco
//        operation.queryCompletionBlock = { cursor, error in
//            DispatchQueue.main.async {
//                if error != nil{
//                    print(error as Any)
//                }else{
//                    print("deu bom")
//                }
//            }
//
//            completion(usuarios)
//        }
//
//        // realizar operacao
//        database.add(operation)
//
//    }
    
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
        database.delete(withRecordID: recordID!) { (deletedRecordID, error) in
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
    
    private func addElementoArrayReferencia(elemento: CKRecord, record: CKRecord, recordType: String) -> [CKRecord.Reference]?{
        
        guard var elementosArray = record[recordType] as? [CKRecord.Reference] else {
            print("erro ao buscar array")
            return nil
        }
        
        let reference = CKRecord.Reference(record: elemento, action: .none)
        
        if !elementosArray.contains(reference){
            elementosArray.append(reference)
            print("deu bom")
        }
        return elementosArray
    }
    
    public func createPrivateUsuario(idFamilia: String, idUser: String){
        
        /// acesso ao container privado do banco
        let database = container.privateCloudDatabase
        /// record criado para ser usado na tabela de UsuarioPrivado
        let record = CKRecord(recordType: "UsuarioPrivado")
        
        // settando valor no record
        record.setValue(idFamilia, forKey: "recordNameFamilia")
        record.setValue(idUser, forKey: "recordNameUsuario")
        
        // salvando os dados no banco
        database.save(record) { (recordSave, error) in
            if error == nil{
                // usuario salvo
                print("dados do usuario salvo")
            } else {
                // usuario nao salvo
                print("dados do usuario nao foram salvos")
                print(error as Any)
            }
        }
    }
    
    /**
     Deleta os dados da tabela UsuarioPrivado
     */
    public func deletePrivateUsuario(){
        /// acesso ao container privado do banco
        let database = container.privateCloudDatabase
        // id do usuario no banco
        let recordID = CKRecord.ID(recordName: "???????????????")
        
        // deleta os dados do usuario do banco
        database.delete(withRecordID: recordID) { (recordID, error) in
            if error == nil {
                // usuario deletado
                print("adeus usuario")
            } else {
                // erro ao deletar usuario
                print("nao deletou o usuario")
                print(error as Any)
            }
        }
    }
    
    public func retrieveFirstPrivateUsuario(familiaUsuario completion: @escaping (String?, String?) -> Void){
        
        var idFamilia: String? = nil
        var idUsuario: String? = nil
        
        let databasePrivate = self.container.privateCloudDatabase
        
        let predicatePrivate = NSPredicate(value: true)
        let queryPrivate = CKQuery(recordType: "UsuarioPrivado", predicate: predicatePrivate)
        
        queryPrivate.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let operationPrivate = CKQueryOperation(query: queryPrivate)
        
        operationPrivate.recordFetchedBlock = { record in
            idFamilia = record["recordNameFamilia"] as String?
            idUsuario = record["recordNameUsuario"] as String?
        }
        
        // para realizar acoes após a busca de dados no banco
        operationPrivate.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error as Any)
                }else{
                    completion(idFamilia, idUsuario)
                }
            }
        }
        
        databasePrivate.add(operationPrivate)
    }
    
    public func retrievePrivateUsuario(completion: @escaping () -> Void){
        
        // User Default
        let defaults = UserDefaults.standard
        
        let idFamilia = defaults.string(forKey: "idFamilia")!
        
        let databasePublic = self.container.publicCloudDatabase
        
        let predicatePublic = NSPredicate(format: "recordName = %@", idFamilia)
        let queryPublic = CKQuery(recordType: "Familia", predicate: predicatePublic)
        
        queryPublic.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let operationPublic = CKQueryOperation(query: queryPublic)
        
        operationPublic.recordFetchedBlock = { record in
            
            self.retrieveFamilia(id: record["recordID"] as! CKRecord.ID, completion: { familia in
                self.familia = familia
            })
        }
        
        operationPublic.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error as Any)
                }else{
                    completion()
                }
            }
        }
        
        databasePublic.add(operationPublic)
    }
    
    public func retrievePrivateUsuario2(completion: @escaping () -> Void){
        
        // User Default
        let defaults = UserDefaults.standard
        
        let idFamilia = defaults.string(forKey: "idFamilia")!
        
        let databasePublic = self.container.publicCloudDatabase
        
        let recordID = CKRecord.ID(recordName: idFamilia)
        
        databasePublic.fetch(withRecordID: recordID) { (record, error) in
            if error == nil{
                print("deu certoooo")
                self.retrieveFamilia(id: recordID, completion: { familia in
                    self.familia = familia
                    completion()
                })
            } else {
                print("erro aaaaaaa")
            }
        }
    }
    
    private func actualUser() -> Usuario?{
        let recordName = UserDefaults.standard.string(forKey: "recordNameUsuario")
        
        for user in self.usuarios{
            if user.recordID?.recordName == recordName{
                return user
            }
        }
        
        return nil
    }
}

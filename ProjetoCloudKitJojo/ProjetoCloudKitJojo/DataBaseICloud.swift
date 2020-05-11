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
        - usuario: usuario a ser criado
     */
    func createUser(usuario: Usuario, completion: @escaping (Usuario) -> Void){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        /// record criado para ser usado no tabela Usuario
        let record = CKRecord(recordType: "Usuario")
        
        var foto = UIImage()
        
        if usuario.foto == nil{
            foto = UIImage(named: "1")!
        } else {
            foto = usuario.foto!
        }
        
        // transformando a UIImage para CKAsset
        guard let asset = transformImage(foto: foto) else { return }
        
        // settando os valores do usuario no record
        record.setValue(usuario.idFamilia, forKey: "idFamilia")
        record.setValue(usuario.nome, forKey: "nome")
        record.setValue(0, forKey: "pontuacao")
        record.setValue([false, false], forKey: "conquista")
        record.setValue(0, forKey: "vitoria")
        record.setValue(0, forKey: "derrota")
        record.setValue(asset, forKey: "foto")
        
        // salvando o usuario no banco
        database.save(record) { (recordSave, error) in
            if error == nil{
                // usuario salvo
                print("Yaaay salvou um usuario")
                // instanciando o usuario usando o record id para adicionar no array do banco
                let user = Usuario(recordID: record.recordID, idFamilia: usuario.idFamilia!, nome: usuario.nome!, pontuacao: 0, foto: foto, conquista: [false], vitoria: 0, derrota: 0)
                // adicionar usuario no array do banco
                self.usuarios.append(user)
                // recupera o id da familia do usuario
                let idFamilia = CKRecord.ID(recordName: usuario.idFamilia!)
                // adiciona o usuario a familia
                self.updateFamiliaAddUsuario(idFamilia: idFamilia, newUser: user)
                completion(user)
            } else {
                // usuario nao salvo
                print("usuario nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    /**
     Atualiza o nome e a foto do usuario atual
     - Parameters:
        - nome: novo nome a ser atualizado
        - foto: nova foto a ser atualizada
     */
    func updateUserNomeFoto(nome: String?, foto: UIImage?){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // busca o usuario atual
        guard let user = actualUser() else { return }
        
        // busca os dados do usuario atual
        guard let userRecord = user.recordID else { return }
        
        // busca o dado compativel com o id
        database.fetch(withRecordID: userRecord) { (record, error) in
            if error == nil{
                // id encontrado
                // armazena o novo valor
                // verifica se tem foto para atualizar
                if let userFoto = foto {
                    guard let asset = self.transformImage(foto: userFoto) else { return }
                    record?.setValue(asset, forKey: "foto")
                }
                
                // verificar se tem nome para atualizar
                if let nomeUser = nome {
                    record?.setValue(nomeUser, forKey: "nome")
                }
                
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
     Atualiza as vitorias e derrotas to usuario
     
     - Parameters:
        - vitoria: true se o usuario ficou em primeiro, false se o usuario ficou em ultimo
     */
    func updateUserVitoriaDerrota(vitoria: Bool){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // busca o usuario atual
        guard let user = actualUser() else { return }
        
        /// identificador do primeiro usuario do array de usuarios
        guard let userRecord = user.recordID else { return }
        
        // busca o dado compativel com o id
        database.fetch(withRecordID: userRecord) { (record, error) in
            if error == nil{
                // id encontrado
                // armazena o novo valor
                if vitoria{
                    // aumenta em 1 a quantidade de vitorias do usuario
                    record?.setValue(user.vitoria! += 1, forKey: "vitoria")
                } else {
                    // aumenta em 1 a quantidade de derrotas do usuario
                    record?.setValue(user.derrota! += 1, forKey: "derrota")
                }
                
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
     Atualiza as conquistas do usuario
     
     - Parameters:
     - novoNome: nome que será sobrescrito no nome atual do usuario
     */
    func updateUserConquista(conquista: Int){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        guard let user = actualUser() else { return }
        
        /// identificador do primeiro usuario do array de usuarios
        guard let userRecord = user.recordID else { return }
        
        user.conquista![conquista] = true
        
        // busca o dado compativel com o id
        database.fetch(withRecordID: userRecord) { (record, error) in
            if error == nil{
                // id encontrado
                // armazena o novo valor
                record?.setValue(user.conquista, forKey: "conquista")
                
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
     atualiza a pontuacao do usuario ao cumprir uma tarefa
     */
    private func updateUserPontuacao(){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // busca o usuario atual
        guard let user = actualUser() else { return }
        
        /// identificador do usuario
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
     - Parameters:
        - id: RecordID da familia do usuario
     */
    func retrieveUser(id: CKRecord.ID, completion: @escaping ([Usuario]) -> Void){
        
        // array de usuarios q substituira o atual
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
    
    /**
     exclui o usuario atual do banco
     */
    
    // TESTAR SE APAGA DA FAMILIA TBM
    func deleteUser(){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        
        // busca usuario atual
        guard let usuario = actualUser() else { return }
        
        // pega o id do usuario
        let recordID = usuario.recordID!
        
        // deleta o usuario do banco a partir do id dele
        database.delete(withRecordID: recordID) { (deletedRecordID, error) in
            if error == nil {
                // deletado com sucesso
                print("Deletado")
                let user = self.actualUser()!
                self.usuarios.removeAll(where: { $0.recordID?.recordName == user.recordID?.recordName })
                self.deletePrivateUsuario()
            } else {
                // nao conseguiu deletar
                print("Nao deletou...")
                print(error as Any)
            }
        }
    }
    
    
    // MARK: - CRUD FAMÍLIA
    
    /**
     cria uma nova familia e salva no banco
     - Parameters:
        - nome: nome da familia
     */
    func createFamilia(nome: String, completion: @escaping (Familia) -> Void){
        
        /// acesso ao container public do banco
        let database = container.publicCloudDatabase
        /// record criado para ser usado na tabela Familia
        let record = CKRecord(recordType: "Familia")
        
        // settando os valores iniciais da familia no record
        record.setValue(nome, forKey: "nome")
        record.setValue(false, forKey: "penalidadeFlag")
        record.setValue(false, forKey: "recompensaFlag")
        record.setValue([], forKey: "atividades")
        record.setValue([], forKey: "usuarios")
        record.setValue("", forKey: "recompensa")
        record.setValue("", forKey: "penalidade")
        
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
    
    /**
     atualiza as conquistas e penalidades da familia no banco
     - Parameters:
        - familia: familia com os dados atualizados
     */
    func updateFamiliaConquistaPenalidade(familia: Familia){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // id da familia
        let idFamilia = self.familia?.recordID
        
        // busca da familia pelo record id
        database.fetch(withRecordID: idFamilia!) { (record, error) in
            if error == nil{
                // encontrou a familia
                // altera os valores da familia
                record?.setValue(familia.penalidade, forKey: "penalidade")
                record?.setValue(familia.penalidadeFlag, forKey: "penalidadeFlag")
                record?.setValue(familia.recompensaFlag, forKey: "recompensaFlag")
                record?.setValue(familia.recompensa, forKey: "recompensa")
                
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
    
    /**
     adiciona usuario na familia
     - Parameters:
        - idFamilia: RecordID da familia
        - newUser: novo usuario a ser adicionado
     */
    private func updateFamiliaAddUsuario(idFamilia: CKRecord.ID, newUser: Usuario){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // id da familia
        let idFamilia = self.familia?.recordID
        
        // busca da familia pelo record id
        database.fetch(withRecordID: idFamilia!) { (record, error) in
            if error == nil{
                // encontrou a familia
                // caso tenha um usuario novo, adiciona ele ao array
                // busca o usuario novo
                let recordUser = CKRecord(recordType: "Usuario", recordID: newUser.recordID!)
                // adiciona o usuario ao array de usuarios
                let arrayUser = self.addElementoArrayReferencia(elemento: recordUser, record: record!, recordType: "usuarios")
                // adiciona a lista de usuarios como novo valor na familia
                record?.setValue(arrayUser, forKey: "usuarios")
                
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
    
    /**
    adiciona atividade na familia
    - Parameters:
       - idFamilia: RecordID da familia
       - newAtividade: nova atividade a ser adicionada
    */
    private func updateFamiliaAddAtividade(idFamilia: CKRecord.ID, newAtividade: Atividade){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // id da familia
        let idFamilia = self.familia?.recordID
        
        // busca da familia pelo record id
        database.fetch(withRecordID: idFamilia!) { (record, error) in
            if error == nil{
                // encontrou a familia
                // caso tenha uma atividade nova, adiciona ela ao array
                // busca atividade nova
                let recordAtividade = CKRecord(recordType: "Atividade", recordID: newAtividade.recordID!)
                //
                let arrayAtividades = self.addElementoArrayReferencia(elemento: recordAtividade, record: record!, recordType: "atividades")
                record?.setValue(arrayAtividades, forKey: "atividades")
                
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
    
    /**
     busca familia do banco a partir do id
     - Parameters:
        - id: RecordID da familia
     */
    func retrieveFamilia(id: CKRecord.ID, completion: @escaping (Familia) -> Void){
        // instancia uma familia
        var familia = Familia(recordID: id)
        
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // fazendo query da tabela de familia buscando somente a familia com ID do parametro
        let predicate = NSPredicate(format: "recordName = %@", id.recordName)
        let query = CKQuery(recordType: "Familia", predicate: predicate)
        
        // determina qual forma os dados serao organizados na busca
        // no caso, sera organizado de forma ascendente e data de criacao da familia
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // operacao da query criada
        let operation = CKQueryOperation(query: query)
        
        // busca os dados da tabela de Atividades
        operation.recordFetchedBlock = { record in
            
            self.retrieveUser(id: record.recordID, completion: {_ in
                self.retrieveAtividade(idFamilia: record.recordID, completion: {_ in
                    
                    // instancia a familia
                    familia = Familia(recordID: record.recordID, nome: record["nome"] as! NSString, usuarios: self.usuarios, atividades: self.atividades, penalidade: (record["penalidade"] as? NSString)!, recompensa: (record["recompensa"] as? NSString)!, penalidadeFlag: record["penalidadeFlag"] as! NSNumber, recompensaFlag: record["recompensaFlag"] as! NSNumber)
                })
            })
        }
        
        // para realizar acoes apos a busca da familia no banco
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.sync {
                if error != nil {
                    // familia nao recuperada
                    print("Erro na recuperacao da Familia!")
                    print(error as Any)
                }else{
                    print("entrou")
                    self.familia = familia
                    completion(familia)
                }
            }
        }
        
        // realiza operacao
        database.add(operation)
    }
    
    /**
     deleta a familia atual
     */
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
        - atividade: atividade a ser criada no banco
     */
    func createAtividade(atividade: Atividade, completion: @escaping (Atividade) -> Void){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        
        // record usado na tabela de Atividade
        let record = CKRecord(recordType: "Atividade")
        
        // id da familia destinada
        let idFamilia = familia!.recordID.recordName
        
        // settando os valores da atividade no record
        if let diaA = atividade.dia{
           record.setValue(diaA, forKey: "dia")
        }
        record.setValue(atividade.nome, forKey: "nome")
        record.setValue(atividade.pontuacao, forKey: "pontuacao")
        record.setValue(idFamilia, forKey: "idFamilia")
        record.setValue(atividade.horario, forKey: "horario")
        record.setValue(atividade.repeticao, forKey: "repeticao")
        record.setValue(atividade.etiqueta, forKey: "etiqueta")
        record.setValue(false, forKey: "realizou")
        
        // salva o record no banco
        database.save(record) { (recordSave, error) in
            if error == nil{
                // salvos com sucesso
                print("Yaaay salvou uma atividade")
                // instanciando atividade
                let atividade = Atividade(recordID: recordSave!.recordID, idFamilia: idFamilia, dia: atividade.dia, etiqueta: atividade.etiqueta!, horario: atividade.horario!, nome: atividade.nome!, pontuacao: atividade.pontuacao!, repeticao: atividade.repeticao!, user: nil, dataFeito: nil, realizou: false)
                completion(atividade)
                // instanciando familia
                let familiaID = CKRecord.ID(recordName: idFamilia)
                // adicionando atividade a familia
                self.updateFamiliaAddAtividade(idFamilia: familiaID, newAtividade: atividade)
            } else {
                // nao salvos
                print("Atividade nao salvou amigao")
                print(error as Any)
            }
        }
    }
    
    /**
     Altera uma atividade ja existente
     
     - Parameters:
        - atividade: atividade com os dados atualizados
     */
    // VOLTA AQUI DEPOIS
    func updateAtividade(atividade: Atividade){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // pega o recordID da primeira atividade do array de atividades
        guard let atividadeID = atividade.recordID else { return }
        
        // busca pela atividade pelo id
        database.fetch(withRecordID: atividadeID) { (record, error) in
            if error == nil{
                // altera o valor do nome da atividade pelo nome novo
                if let diaA = atividade.dia{
                   record?.setValue(diaA, forKey: "dia")
                }
                record?.setValue(atividade.nome, forKey: "nome")
                record?.setValue(atividade.pontuacao, forKey: "pontuacao")
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
    
    // TESTAR SE A PONTUACAO DO USER TA SENDO ALTERADA
    /**
     funcao para mudar os status da atividade para realizada no banco
     
     - Parameters:
        - atividade: atividade que foi concluida
     */
    func updateAtividadeRealizada(atividade: Atividade){
        /// acesso ao container publico do banco
        let database = self.container.publicCloudDatabase
        
        // pega o recordID da primeira atividade do array de atividades
        guard let atividadeID = atividade.recordID else { return }
        guard let user = self.actualUser() else { return }
        guard let userID = user.recordID else { return }
        
        // setta o usuario como uma referencia a tabela de usuarios na tabela de atividades
        let reference = CKRecord.Reference(recordID: userID, action: CKRecord_Reference_Action.none)
        
        // pegar a hora em que a atividade foi realizada
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
        
        // adiciona pontuacao para o usuario atual
        user.pontuacao! += atividade.pontuacao!
        
        // atualiza a pontuacao do usuario no banco
        self.updateUserPontuacao()
    }
    
    // TESTAR O QUE ACONTECE QUANDO O USUARIO Q REALIZOU A ATIVIDADE SAIU DA FAMILIA (BANCO)
    /**
     Busca as atividades do iCloud
     
     - Parameters:
        - idFamilia: RecordID da familia que deseja buscar atividades
     */
    public func retrieveAtividade(idFamilia: CKRecord.ID, completion: @escaping ([Atividade]) -> Void){
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
        
        // array de atividades para substituir array atual da classe
        var atividadesFamilia = [Atividade]()
        
        // busca os dados da tabela de Atividades
        operation.recordFetchedBlock = { record in
            
            var activity = Atividade()
            
            // busca a referencia do usuario na tabela de Atividade
            if let userReference = record["usuario"] as? CKRecord.Reference{
                // busca pela referencia do usuario na tabela de usuario
                database.fetch(withRecordID: CKRecord.ID(recordName: (userReference.recordID.recordName))) { (recordUser, error) in
                    // instancia o usuario a partir dos valores do usuario da tabela de atividades
                    var user = Usuario()
                    
                    for usuario in self.usuarios {
                        if usuario.recordID?.recordName == recordUser?.recordID.recordName{
                            user = usuario
                        }
                    }
                    
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
    
    /**
     Deleta atividade no iCloud
     
     - Parameters:
     - atividade: atividade que sera deletada do banco
     */
    public func deleteAtividade(atividade: Atividade){
        /// acesso ao container publico do banco
        let database = container.publicCloudDatabase
        // id da atividade no banco
        let recordID = atividade.recordID
        
        // deleta a atividade no banco a partir do ID dela
        database.delete(withRecordID: recordID!) { (deletedRecordID, error) in
            if error == nil {
                // deletado
                print("Deletado")
                self.atividades.removeAll(where: { $0.recordID?.recordName == atividade.recordID?.recordName })
            } else {
                // nao deletado
                print("Nao deletou...")
                print(error as Any)
            }
        }
    }
    
    // MARK: - Usuario Private
    
    /**
     adiciona a familia e o usuario ao icloud privado do usuario
     
     - Parameters:
        - idFamilia: RecordName da familia
        - idUser: RecordName do usuario
     */
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
        
        let recordName = UserDefaults.standard.string(forKey: "idFamilia")
        
        // id do usuario no banco
        let recordID = CKRecord.ID(recordName: recordName!)
        
        // deleta os dados do usuario do banco
        database.delete(withRecordID: recordID) { (recordID, error) in
            if error == nil {
                // usuario deletado
                print("adeus usuario")
                UserDefaults.standard.set(nil, forKey: "idFamilia")
                UserDefaults.standard.set(nil, forKey: "idUsuario")
            } else {
                // erro ao deletar usuario
                print("nao deletou o usuario")
                print(error as Any)
            }
        }
    }
    
    /**
     busca o recordname da familia e do usuario e coloca no user defaults
     */
    public func retrieveFirstPrivateUsuario(familiaUsuario completion: @escaping (String?, String?) -> Void){
        
        // verifica se existe os dados no user defaults
        if(UserDefaults.standard.string(forKey: "idFamilia") != nil){
            completion(nil, nil)
            return
        }
        
        // cria variaveis de id da familia e usuario
        var idFamilia = ""
        var idUsuario = ""
        
        // acesso ao
        let databasePrivate = self.container.privateCloudDatabase
        
        // fazer query do usuario privado
        let predicatePrivate = NSPredicate(value: true)
        let queryPrivate = CKQuery(recordType: "UsuarioPrivado", predicate: predicatePrivate)
        queryPrivate.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let operationPrivate = CKQueryOperation(query: queryPrivate)
        
        // busca os dados
        operationPrivate.recordFetchedBlock = { record in
            idFamilia = record["recordNameFamilia"] as! String
            idUsuario = record["recordNameUsuario"] as! String
        }
        
        // para realizar acoes após a busca de dados no banco
        operationPrivate.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error as Any)
                }else{
                    UserDefaults.standard.set(idFamilia, forKey: "idFamila")
                    UserDefaults.standard.set(idUsuario, forKey: "idUsuario")
                    completion(idFamilia, idUsuario)
                }
            }
        }
        
        databasePrivate.add(operationPrivate)
    }
    
    /**
     busca a familia a partir do recordname da usuario privado
     */
    public func retrievePrivateUsuario(completion: @escaping () -> Void){
        
        // User Default
        let defaults = UserDefaults.standard
        
        // recordname da familia
        let idFamilia = defaults.string(forKey: "idFamilia")!
        
        // acesso ao container publico
        let databasePublic = self.container.publicCloudDatabase
        
        // recordID da familia
        let recordID = CKRecord.ID(recordName: idFamilia)
        
        // busca a familia e instancia para o programa
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
    
    /**
     transforma um elemento em um array de referencias
     - Parameters:
        - elemento: elemento que faz parte da referencia
        - record: record que possui array de referencias
        - recordType: o recordType das referencias
     */
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
    
    /**
     busca o usuario atual do app
     */
    private func actualUser() -> Usuario?{
        // id do usuario atual
        let recordName = UserDefaults.standard.string(forKey: "recordNameUsuario")
        
        // busca pelo array do banco
        for user in self.usuarios{
            if user.recordID?.recordName == recordName{
                return user
            }
        }
        
        return nil
    }
}

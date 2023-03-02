//
//  AccountManager.swift
//  Bankey
//
//  Created by Edwin Cardenas on 3/1/23.
//

import Foundation

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
    
    static func makeSkeleton() -> Account {
        return Account(id: "1", type: .Banking, name: "Account name", amount: 0.0, createdDateTime: Date())
    }
}

protocol AccountManageable: AnyObject {
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void)
}

class AccountManager: AccountManageable {
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
        guard let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)/accounts") else { fatalError("Could not convert to URL") }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(.serverError))
                    
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let accounts = try decoder.decode([Account].self, from: data)
                    completion(.success(accounts))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
        
        task.resume()
    }
}

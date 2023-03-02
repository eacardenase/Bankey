//
//  ProfileManager.swift
//  Bankey
//
//  Created by Edwin Cardenas on 3/1/23.
//

import Foundation

struct Profile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

protocol ProfileManageable: AnyObject {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void)
}

class ProfileManager: ProfileManageable {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    
                    return
                }
                
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    
                    completion(.success(profile))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
        
        task.resume()
    }
}

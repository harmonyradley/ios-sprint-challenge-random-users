//
//  UserController.swift
//  Random Users
//
//  Created by Harmony Radley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case badURL
    case badData
    case noDecode
    case failedFetch
}

class UserController {

    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    typealias CompetionHandler = (Result<[User], NetworkError>) -> Void

    func fetchRandomUser(completion: @escaping CompetionHandler) {

        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                NSLog("Error getting users: \(error)")
                completion(.failure(.failedFetch))
                return
            }

            guard let data = data else {
                NSLog("Error returned from data.")
                completion(.failure(.badData))
                return
            }

            do {
                let decoder = try JSONDecoder().decode(Results.self, from: data)
                let users = decoder.users
                completion(.success(users))
                return
            } catch {
                NSLog("Error decoding User objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
}

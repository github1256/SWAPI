//
//  APIService.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import TinyNetworking
import UIKit

public class APIService {
    static let shared = APIService()
    
    let baseUrl = "https://swapi.dev/api/people/"
    
    func fetchPeople(completion: @escaping (Result<[People], Error>) -> Void) {
        guard let url = URL(string: baseUrl) else { print("Error: \(baseUrl) is not a valid URL."); return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // back to main thread
            DispatchQueue.main.async {
                if let error = error {
                    // Network Failure
                    completion(.failure(error))
                }
                
                guard let safeData = data else { return }
                
                let stringData = String(decoding: safeData, as: UTF8.self)
                print(stringData)
                
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let people = try decoder.decode([People].self, from: safeData)
//                    completion(.success(people))
//
//                } catch let jsonError {
//                    completion(.failure(jsonError))
//                }
            }
        }.resume()
    }
}

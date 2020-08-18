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
    
    func fetchPeople(completion: @escaping (Result<[People], Error>) -> Void) {
        let baseUrl = "https://swapi.dev/api/people/"
        guard let url = URL(string: baseUrl) else { print("Error: \(baseUrl) is not a valid URL."); return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // back to main thread
            DispatchQueue.main.async {
                if let error = error {
                    // Network Failure
                    completion(.failure(error))
                }
                
                guard let safeData = data else { return }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let searchResult = try decoder.decode(SearchResults.self, from: safeData)
                    completion(.success(searchResult.results))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}

struct SearchResults: Codable {
    let count: Int
    let next: URL
    let previous: URL
    let results: [People]
}

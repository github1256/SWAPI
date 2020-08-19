//
//  APIService.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

final class APIClient {
    //    private lazy var baseUrl: URL = {
    //        let urlString = "https://swapi.dev/api/people/"
    //        guard let url = URL(string: urlString) else { fatalError("Error: \(urlString) is not a valid URL.") }
    //        return url
    //    }()
    
    func fetchPeople(page: Int, completion: @escaping (Result<RootResponse, NetworkError>) -> Void) {
        
        let baseUrl = "httpss://swapi.dev/api/people/"
        let urlString: String
        
        if page == 1 {
            urlString = baseUrl
        } else {
            urlString = baseUrl + "?page=\(page)"
        }
        
        // check if URL is valid
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("Fetching a list of Star Wars characters from...", url)
            
            // Back to Main Thread
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                }

                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode),
                    let safeData = data
                    else {
                        completion(.failure(.requestFailed))
                        return
                }
                
                //guard let safeData = data else { return }
                
                // If response is valid, decode JSON
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let decodedResponse = try decoder.decode(RootResponse.self, from: safeData)
                    
                    // Convert data to a string
                    // let stringData = String(decoding: safeData, as: UTF8.self)
                    
                    completion(Result.success(decodedResponse))
                } catch {
                    completion(Result.failure(.decodingFailed))
                }
            }
        }.resume()
    }
}

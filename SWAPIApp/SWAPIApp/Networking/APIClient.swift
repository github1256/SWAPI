//
//  APIService.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

final class APIClient {
    
    func fetchPeople(page: Int, completion: @escaping (Result<RootResponse, NetworkError>) -> Void) {
        
        let baseUrl = "https://swapi.dev/api/people/"
        
        // create urlString depending on page to retrieve
        let urlString = page == 1 ? baseUrl : baseUrl + "?page=\(page)"
        
        // check if URL is valid
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("Fetching list of Star Wars characters from:", url)
            
            // back to main thread
            //DispatchQueue.main.async {
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
                
                // if response is valid, decode JSON
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let decodedResponse = try decoder.decode(RootResponse.self, from: safeData)
                    
                    // convert data to a string to check response
                    // let stringData = String(decoding: safeData, as: UTF8.self)
                    
                    completion(Result.success(decodedResponse))
                } catch {
                    completion(Result.failure(.decodingFailed))
                }
            //}
        }.resume()
    }
}

//
//  APIService.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

// Final Declaration to prevent inheritance from other classes
final class APIClient {
    
    var cachedUrl: URL?
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
      self.session = session
    }
    
    func fetchFilm(with url: URL, completion: @escaping (Result<Film, NetworkError>) -> Void) {
        
        self.cachedUrl = url
        
        session.dataTask(with: url) { (data, response, error) in
            
            // Back to main thread
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                // Check if HTTP response is successful and data is safe
                // Otherwise return with a failure
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode),
                    let safeData = data
                    else {
                        completion(.failure(.requestFailed))
                        return
                }
                
                // If response is valid, decode JSON
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let film = try decoder.decode(Film.self, from: safeData)
                    completion(Result.success(film))
                } catch {
                    completion(Result.failure(.decodingFailed))
                }
            }
        }.resume()
    }
    
    func fetchPeople(page: Int, completion: @escaping (Result<RootResponse, NetworkError>) -> Void) {
        let baseUrl = "https://swapi.dev/api/people/"
        
        // If we are on page 1, use the base url
        // Otherwise create urlString with the corresponding page
        let urlString = page == 1 ? baseUrl : baseUrl + "?page=\(page)"
        
        // Check if URL is valid, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        self.cachedUrl = url

        session.dataTask(with: url) { (data, response, error) in
            
            // Back to main thread
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                // Check if HTTP response is successful and that data is safe
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode),
                    let safeData = data
                    else {
                        completion(.failure(.requestFailed))
                        return
                }
                
                // If response is valid, decode JSON
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedResponse = try decoder.decode(RootResponse.self, from: safeData)
                    completion(Result.success(decodedResponse))
                } catch {
                    completion(Result.failure(.decodingFailed))
                }
            }
        }.resume()
    }
}

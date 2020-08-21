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
    private let baseUrlString = "https://swapi.dev/api/people/"
    private lazy var baseUrl: URL = {
        return URL(string: baseUrlString)!
    }()
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
      self.session = session
    }
    
    // Uses generics to create reusable function
    func fetch<T: Decodable>(with url: URL?, page: Int?, dataType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request: URL = baseUrl
        if let url = url { request = url }
        
        // API Pagination
        if let page = page {
            // Create url string with the corresponding page
            let urlString: String
            urlString = page == 1 ? baseUrlString : baseUrlString + "?page=\(page)"
            guard let url = URL(string: urlString) else {
                completion(.failure(.invalidUrl))
                return
            }
            request = url
        }
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            print("fetching", request)
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            // Check if HTTP response is successful and data is safe
            // Otherwise return with a failure
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let safeData = data
                else {
                    DispatchQueue.main.async {
                        completion(.failure(.unknown))
                    }
                    return
            }
            // If response is valid, decode JSON
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(dataType, from: safeData)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch let jsonError {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed(jsonError)))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func fetchFilm(with url: URL, completion: @escaping (Result<Film, NetworkError>) -> Void) {
//        session.dataTask(with: url) { (data, response, error) in
//            
//            // Back to main thread
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//                
//                // Check if HTTP response is successful and data is safe
//                // Otherwise return with a failure
//                guard let httpResponse = response as? HTTPURLResponse,
//                    (200...299).contains(httpResponse.statusCode),
//                    let safeData = data
//                    else {
//                        completion(.failure(.unknown))
//                        return
//                }
//                
//                // If response is valid, decode JSON
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let film = try decoder.decode(Film.self, from: safeData)
//                    completion(Result.success(film))
//                } catch let jsonError {
//                    completion(Result.failure(.decodingFailed(jsonError)))
//                }
//            }
//        }.resume()
//    }
    
    
    
    
    
    
//    func fetchPeople(page: Int, completion: @escaping (Result<RootResponse, NetworkError>) -> Void) {
//
//        // Create url string with the corresponding page
//        let urlString: String
//        if page == 1 {
//            urlString = baseUrl
//        } else {
//            urlString = baseUrl + "?page=\(page)"
//        }
//
//        // Check if URL is valid, otherwise return with a failure
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.unknown))
//            return
//        }
//
//
//
//        session.dataTask(with: url) { (data, response, error) in
//
//            // Back to main thread
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//
//                // Check if HTTP response is successful and that data is safe
//                guard let httpResponse = response as? HTTPURLResponse,
//                    (200...299).contains(httpResponse.statusCode),
//                    let safeData = data
//                    else {
//                        completion(.failure(.unknown))
//                        return
//                }
//
//                // If response is valid, decode JSON
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let decodedResponse = try decoder.decode(RootResponse.self, from: safeData)
//                    completion(Result.success(decodedResponse))
//                } catch let jsonError {
//                    completion(Result.failure(.decodingFailed(jsonError)))
//                }
//            }
//        }.resume()
//    }
}

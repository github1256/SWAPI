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
    
    // MARK: - Network Call
    
    // Uses generics to create reusable function
    func fetch<T: Decodable>(with url: URL?, page: Int?, dataType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request: URL = baseUrl
        
        // If URL exists use it
        if let url = url { request = url }
        
        // API Pagination
        // If there are multiple pages of results...
        if let page = page {
            // ... create url string with the corresponding page number
            let urlString: String
            urlString = page == 1 ? baseUrlString : baseUrlString + "?page=\(page)"
            guard let url = URL(string: urlString) else { return }
            request = url
        }
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
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
}

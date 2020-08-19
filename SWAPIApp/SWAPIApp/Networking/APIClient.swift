//
//  APIService.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

final class APIClient {
    private lazy var baseUrl: URL = {
        let urlString = "https://swapi.dev/api/people/"
        guard let url = URL(string: urlString) else { fatalError("Error: \(urlString) is not a valid URL.") }
        return url
    }()
    
    //    let session: URLSession
    //
    //    init(session: URLSession = URLSession.shared) {
    //        self.session = session
    //    }
    
    var starWarsPeople: [People] = []
    
    func fetchPeople(page: Int, completion: @escaping (Result<PagedResult, NetworkError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseUrl)
        //let urlRequest = URLRequest(url: baseUrl.appendingPathComponent(request.peoplePath))
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            print("Fetching a list of Star Wars characters...")
            
            // Back to Main Thread
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.requestFailed))
                }
                
                #warning("handle HTTPURLResponse")
                
                guard let safeData = data else { return }
                
                // If response is valid, decode JSON
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let decodedResult = try decoder.decode(PagedResult.self, from: safeData)
                    completion(Result.success(decodedResult))
                } catch {
                    completion(Result.failure(.decodingFailed))
                }
            }
        }.resume()
    }
}

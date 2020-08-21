//
//  StarWarsViewModel.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

protocol StarWarsViewModelDelegate: class {
    func fetchDidSucceed()
    func fetchDidFail(with title: String, description: String)
}

// Final Declaration to prevent inheritance from other classes
final class StarWarsViewModel {
    private weak var delegate: StarWarsViewModelDelegate?
    
    init(delegate: StarWarsViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Variables and Properties
    
    let apiClient = APIClient()
    
    private var films: [Film] = []
    private var starWarsPeople: [Person] = [] {
        didSet {
            // Keep track of fetched characters and compare with total on server
            // Fetch next page of results until all characters are fetched
            if currentCount < totalCount {
                fetchPeople()
            } else {
                // When all characters are fetched, sort alphabetically,
                // and reload table view with data
                self.starWarsPeople.sort { $0.name < $1.name }
                self.delegate?.fetchDidSucceed()
            }
        }
    }
    
    private var currentPage = 1
    private var total = 0
    var currentCount: Int { return starWarsPeople.count }
    var totalCount: Int { return total }
    
    // MARK: - Internal Methods
    
    func findPerson(at index: Int) -> Person {
        return starWarsPeople[index]
    }
    
    func findFilms() -> [Film] {
        return films
    }
    
    // MARK: - Fetch Data
    
    func fetchPeople() {
        
        //apiClient.fetchPeople(page: currentPage) { result in
        
        apiClient.fetch(with: nil, page: currentPage, dataType: RootResponse.self) { result in
            switch result {
            case .failure(let error):
                // Perform on main thread to update UI
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: error.reason, description: error.localizedDescription)
                }
            case .success(let response):
                // Perform on main thread to update UI
                DispatchQueue.main.async {
                    // Store total number of characters available on the server
                    self.total = response.count
                    
                    // Increment the page number to fetch the next page of results
                    self.currentPage += 1
                    
                    // Store the latest fetched characters
                    self.starWarsPeople.append(contentsOf: response.results)
                    
                    self.delegate?.fetchDidSucceed()
                }
            }
        }
        
        
        
        
        //        apiClient.fetchPeople(page: currentPage) { result in
        //            switch result {
        //            case .failure(let error):
        //                // Perform on main thread to update UI
        //                DispatchQueue.main.async {
        //                    self.delegate?.fetchDidFail(with: error.reason, description: error.localizedDescription)
        //                }
        //            case .success(let response):
        //                // Perform on main thread to update UI
        //                DispatchQueue.main.async {
        //                    // Store total number of characters available on the server
        //                    self.total = response.count
        //
        //                    // Increment the page number to fetch the next page of results
        //                    self.currentPage += 1
        //
        //                    // Store the latest fetched characters
        //                    self.starWarsPeople.append(contentsOf: response.results)
        //
        //                    self.delegate?.fetchDidSucceed()
        //                }
        //            }
        //        }
    }
    
    func fetchFilm(with url: URL) {
        //apiClient.fetchFilm(with: url) { result in
        apiClient.fetch(with: url, page: nil, dataType: Film.self) { result in
            switch result {
            case .failure(let error):
                // Perform on main thread to update UI
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: error.reason, description: error.localizedDescription)
                }
            case .success(let film):
                // Perform on main thread to update UI
                DispatchQueue.main.async {
                    self.films.append(film)
                    self.delegate?.fetchDidSucceed()
                }
            }
        }
    }
    
    
    
    //        apiClient.fetchFilm(with: url) { result in
    //            switch result {
    //            case .failure(let error):
    //                // Perform on main thread to update UI
    //                DispatchQueue.main.async {
    //                    self.delegate?.fetchDidFail(with: error.reason, description: error.localizedDescription)
    //                }
    //            case .success(let film):
    //                // Perform on main thread to update UI
    //                DispatchQueue.main.async {
    //                    self.films.append(film)
    //                    self.delegate?.fetchDidSucceed()
    //                }
    //            }
    //        }
}


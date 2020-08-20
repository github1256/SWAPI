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
            // fetch next page of results until entire list if fetched
            if currentCount < totalCount {
                fetchPeople()
            } else {
                // sort alphabetically
                self.starWarsPeople.sort { $0.name < $1.name }
                self.delegate?.fetchDidSucceed()
            }
        }
    }
    
    private var currentPage = 1
    private var total = 0
    
    var totalCount: Int { return total }
    var currentCount: Int { return starWarsPeople.count }
    
    // MARK: - Internal Methods
    
    func findPerson(at index: Int) -> Person {
        return starWarsPeople[index]
    }
    
    func findFilms() -> [Film] { return films }
    
    // MARK: - Fetch Data
    
    func fetchPeople() {
        apiClient.fetchPeople(page: currentPage) { result in
            switch result {
            case .failure(let error):
                // perform on main thread to update UI
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: error.reason, description: error.localizedDescription)
                }
            case .success(let response):
                // perform on main thread to update UI
                DispatchQueue.main.async {
                    
                    // increment the page number to fetch next page of results
                    self.currentPage += 1
                    
                    // store total # of characters on the server
                    self.total = response.count
                    
                    // store latest fetched characters
                    self.starWarsPeople.append(contentsOf: response.results)
                    
                    self.delegate?.fetchDidSucceed()
                }
            }
        }
    }
    
    func fetchFilms(with url: URL) {
        apiClient.fetchFilm(with: url) { result in
            switch result {
            case .failure(let error):
                // perform on main thread to update UI
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: error.reason, description: error.localizedDescription)
                }
            case .success(let film):
                // perform on main thread to update UI
                DispatchQueue.main.async {
                    // store latest fetched characters
                    self.films.append(film)
                    self.delegate?.fetchDidSucceed()
                }
            }
        }
    }
}

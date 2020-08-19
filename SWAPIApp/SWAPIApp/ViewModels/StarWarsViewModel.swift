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
    
    private var starWarsPeople: [People] = []
    private var currentPage = 1
    private var total = 0
    
    let apiClient = APIClient()
    
    var totalCount: Int { return total }
    var currentCount: Int {
        return starWarsPeople.count
    }
    
    func findPerson(at index: Int) -> People {
        return starWarsPeople[index]
    }
    
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
                    
                    // Increment the page number
                    self.currentPage += 1
                    
                    // Store total # of characters on the server
                    // Store latest fetched characters
                    self.total = response.count
                    self.starWarsPeople.append(contentsOf: response.results)
                    
                    self.delegate?.fetchDidSucceed()
                }
            }
        }
    }
}

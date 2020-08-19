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
    func fetchDidFail(with reason: String)
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
    //let request: SwapiRequest
    
    var totalCount: Int { return total }
    var currentCount: Int { return starWarsPeople.count }
    
    func findPerson(at index: Int) -> People {
      return starWarsPeople[index]
    }
    
    func fetchPeople() {
        apiClient.fetchPeople(page: currentPage) { result in
            switch result {
            
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: error.description)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.total = response.count
                    self.delegate?.fetchDidSucceed()
                }
            }
        }
    }
    
}

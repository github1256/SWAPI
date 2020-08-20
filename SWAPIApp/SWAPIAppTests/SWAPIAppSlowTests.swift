//
//  SWAPIAppTests.swift
//  SWAPIAppTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import XCTest
@testable import SWAPIApp

class SWAPIAppSlowTests: XCTestCase {
    // System Under Test
    var sut: URLSession!
    
    override func setUp() {
      super.setUp()
      sut = URLSession(configuration: .default)
    }
    
    override func tearDown() {
      sut = nil
      super.tearDown()
    }
    
    // MARK: - Asynchronous Tests: API Call

    func testValidCallToSWAPIReturnsCompletion() {
        let url = URL(string: "http://swapi.dev/api/people/?page=3")
        // What we expect to happen
        let promise = expectation(description: "Returns Completion handler")
        var statusCode: Int?
        var responseError: Error?
        let dataTask = sut.dataTask(with: url!) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            statusCode = httpResponse?.statusCode
            responseError = error
            // When app receives a response, expectation is fulfilled
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    


    
    
    
    

    

    func testFetchPeopleSuccessReturnsRootResponse() {
        let apiClient = APIClient()
        let promise = expectation(description: "completion handler invoked with response")
        var rootResponse: RootResponse?
        apiClient.fetchPeople(page: 1) { result in
            switch result {
            case .success(let response):
                rootResponse = response
                promise.fulfill()
            case .failure:
                break
            }
        }
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(rootResponse)
        }
    }
    
    func testFetchPeopleFailureReturnsError() {
        let apiClient = APIClient()
        let promise = expectation(description: "completion handler invoked with error")
        var errorResponse: NetworkError?
        apiClient.fetchPeople(page: 100) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                errorResponse = error
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testFetchFilmSuccessReturnsFilm() {
        let apiClient = APIClient()
        guard let url = URL(string: "http://swapi.dev/api/films/4/") else { return }
        let promise = expectation(description: "completion handler invoked with film")
        var filmResponse: Film?
        apiClient.fetchFilm(with: url) { result in
            switch result {
            case .success(let response):
                filmResponse = response
                promise.fulfill()
            case .failure:
                break
            }
        }
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(filmResponse)
        }
    }
    
    func testFetchFilmFailureReturnsError() {
        let apiClient = APIClient()
        guard let url = URL(string: "invalidUrl") else { return }
        let promise = expectation(description: "completion handler invoked with error")
        var errorResponse: NetworkError?
        apiClient.fetchFilm(with: url) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                errorResponse = error
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(errorResponse)
        }
    }
}

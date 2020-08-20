//
//  SWAPIAppTests.swift
//  SWAPIAppTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import XCTest
@testable import SWAPIApp

class SWAPIAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWordCountExtension() {
        let testString = "Luke Skywalker has returned to\r\nhis home planet of Tatooine in\r\nan attempt to rescue his\r\nfriend Han Solo from the\r\nclutches of the vile gangster\r\nJabba the Hutt.\r\n\r\nLittle does Luke know that the\r\nGALACTIC EMPIRE has secretly\r\nbegun construction on a new\r\narmored space station even\r\nmore powerful than the first\r\ndreaded Death Star.\r\n\r\nWhen completed, this ultimate\r\nweapon will spell certain doom\r\nfor the small band of rebels\r\nstruggling to restore freedom\r\nto the galaxy..."
        let wordCount = testString.wordCount
        XCTAssertEqual(wordCount, 78)
        
        let testString2 = "Turmoil has engulfed the\r\nGalactic Republic. The taxation\r\nof trade routes to outlying star\r\nsystems is in dispute.\r\n\r\nHoping to resolve the matter\r\nwith a blockade of deadly\r\nbattleships, the greedy Trade\r\nFederation has stopped all\r\nshipping to the small planet\r\nof Naboo.\r\n\r\nWhile the Congress of the\r\nRepublic endlessly debates\r\nthis alarming chain of events,\r\nthe Supreme Chancellor has\r\nsecretly dispatched two Jedi\r\nKnights, the guardians of\r\npeace and justice in the\r\ngalaxy, to settle the conflict...."
        let wordCount2 = testString2.wordCount
        XCTAssertEqual(wordCount2, 78)
    }
    
    // MARK: - API Tests
    
    func testFetchPeopleWithURL() {
        let apiClient = APIClient()
        apiClient.fetchPeople(page: 1) { result in }
        XCTAssertEqual(apiClient.cachedUrl?.host, "swapi.dev")
        XCTAssertEqual(apiClient.cachedUrl?.path, "/api/people")
        XCTAssertEqual(apiClient.cachedUrl?.absoluteString, "https://swapi.dev/api/people/")
        
        apiClient.fetchPeople(page: 2) { result in }
        XCTAssertEqual(apiClient.cachedUrl?.absoluteString, "https://swapi.dev/api/people/?page=2")
    }
    
    func testFetchFilmWithURL() {
        let apiClient = APIClient()
        guard let url = URL(string: "http://swapi.dev/api/films/4/") else { return }
        apiClient.fetchFilm(with: url) { result in }
        XCTAssertEqual(apiClient.cachedUrl?.host, "swapi.dev")
        XCTAssertEqual(apiClient.cachedUrl?.path, "/api/films/4")
    }

    func testFetchPeopleSuccessReturnsRootResponse() {
        let apiClient = APIClient()
        let rootExpectation = expectation(description: "root response")
        var rootResponse: RootResponse?
        apiClient.fetchPeople(page: 1) { result in
            switch result {
            case .success(let response):
                rootResponse = response
                rootExpectation.fulfill()
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
        let errorExpectation = expectation(description: "error")
        var errorResponse: NetworkError?
        apiClient.fetchPeople(page: 100) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                errorResponse = error
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testFetchFilmSuccessReturnsRootResponse() {
        let apiClient = APIClient()
        guard let url = URL(string: "http://swapi.dev/api/films/4/") else { return }
        let filmExpectation = expectation(description: "film")
        var filmResponse: Film?
        apiClient.fetchFilm(with: url) { result in
            switch result {
            case .success(let response):
                filmResponse = response
                filmExpectation.fulfill()
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
        let errorExpectation = expectation(description: "film")
        var errorResponse: NetworkError?
        apiClient.fetchFilm(with: url) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                errorResponse = error
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(errorResponse)
        }
    }
}
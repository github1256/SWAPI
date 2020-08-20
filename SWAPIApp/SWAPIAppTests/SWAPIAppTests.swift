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
    
    // MARK: - Word Count Extension
    
    func testWordCountExtensionReturnsCorrectCount() {
        let sampleOpeningCrawlText = "Luke Skywalker has returned to\r\nhis home planet of Tatooine in\r\nan attempt to rescue his\r\nfriend Han Solo from the\r\nclutches of the vile gangster\r\nJabba the Hutt.\r\n\r\nLittle does Luke know that the\r\nGALACTIC EMPIRE has secretly\r\nbegun construction on a new\r\narmored space station even\r\nmore powerful than the first\r\ndreaded Death Star.\r\n\r\nWhen completed, this ultimate\r\nweapon will spell certain doom\r\nfor the small band of rebels\r\nstruggling to restore freedom\r\nto the galaxy..."
        let wordCount = sampleOpeningCrawlText.wordCount
        XCTAssertEqual(wordCount, 78)
    }
    
    func testWordCountExtensionReturnsCorrectCountForSampleText() {
        let sampleText = "Can Montreal open the trilogy? 452 withdraws! A scratching taxi leaps against a counsel. An entertaining campaign faints. The fatuous handful allies 452 across the catholic."
        let wordCount = sampleText.wordCount
        XCTAssertEqual(wordCount, 26)
    }
    
    // MARK: - API Tests

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

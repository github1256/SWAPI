//
//  SWAPIAppFakeTests.swift
//  SWAPIAppFakeTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import XCTest
@testable import SWAPIApp

struct TestPayload: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [Person]
}

class SWAPIAppFakeTests: XCTestCase {
    var sut: StarWarsViewModel!
    let apiUrl = URL(string: "http://swapi.dev/api/people/")!
    
    override func setUp() {
        super.setUp()
        sut = StarWarsViewModel(delegate: self)
        
        // Inject URLSession configured with URLProtocolStub
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        sut.apiClient = APIClient(session: session)
    }

    override func tearDown() {
        sut = nil
        URLProtocolStub.requestHandler = nil
        super.tearDown()
    }
    
    func testFetchingDataSuccess() {
        // Decode mock JSON data from page 1 of results
        let jsonPath = Bundle(for: type(of: self)).path(forResource: "starWarsData", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        
        // Call handler with a request and return mock response
        // In this example, we are only validating a URL
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (jsonData, response, nil)
        }
        
        // Call API
        let promise = expectation(description: "Success Response from Fetching Data")
        sut.apiClient.fetch(with: nil, page: nil, dataType: TestPayload.self) { result in
            switch result {
            case .success(let payload):
                XCTAssertEqual(payload.count, 82)
                XCTAssertEqual(payload.next, URL(string: "http://swapi.dev/api/people/?page=2"))
                XCTAssertEqual(payload.previous, nil)
            case .failure(let error):
                XCTFail("Unexpected Failure Reponse: \(error.localizedDescription)")
            }
            // When app receives a response, expectation is fulfilled
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testFetchingDataFailure() {
        // Use incorrect JSON data to check for decoding error
        let incorrectData = Data()
        
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (incorrectData, response, nil)
        }
        
        // Call API
        let promise = expectation(description: "Failure Response from Fetching Data")
        sut.apiClient.fetch(with: nil, page: nil, dataType: TestPayload.self) { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected Success Response")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.decoding)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}

// MARK: - StarWarsViewModelDelegate

extension SWAPIAppFakeTests: StarWarsViewModelDelegate {
    func fetchDidSucceed() { }
    func fetchDidFail(with title: String, description: String) { }
}

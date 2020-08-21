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
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        sut.apiClient = APIClient(session: session)
    }

    override func tearDown() {
        URLProtocolStub.requestHandler = nil
        super.tearDown()
    }
    
    func testFetchingDataSuccess() {
        // Decoding mock pre-fetched JSON
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "starWarsData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        //let jsonUrl = Bundle.main.url(forResource: "starWarsData", withExtension: "json")
        //let jsonData = try? Data(contentsOf: jsonUrl!)
        
        URLProtocolStub.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (data, response, nil)
        }
        
        // Call API
        let promise = expectation(description: "Status code: 200")
        sut.apiClient.fetch(with: apiUrl, page: nil, dataType: TestPayload.self) { result in
            switch result {
            case .success(let payload):
                XCTAssertEqual(payload.count, 82)
                XCTAssertEqual(payload.next, URL(string: "http://swapi.dev/api/people/?page=2"))
                XCTAssertEqual(payload.previous, nil)
            case .failure(let error):
                XCTFail("Request Failed: \(error.localizedDescription)")
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

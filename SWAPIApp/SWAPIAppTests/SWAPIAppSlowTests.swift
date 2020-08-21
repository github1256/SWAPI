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
        let url = URL(string: "http://swapi.dev/api/people/?page=4")
        let promise = expectation(description: "Returns completion handler")
        
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sut.dataTask(with: url!) { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            
            // When app receives a response, expectation is fulfilled
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}

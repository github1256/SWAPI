//
//  SWAPIAppFakeTests.swift
//  SWAPIAppFakeTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import XCTest
@testable import SWAPIApp

class SWAPIAppFakeTests: XCTestCase {
    var sut: StarWarsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = StarWarsViewModel(delegate: self)
    }
    
    override func tearDown() {
      sut = nil
      super.tearDown()
    }
    
    // MARK: - Fake Tests: StarWarsViewModel
    
    
    
}

extension SWAPIAppFakeTests: StarWarsViewModelDelegate {
    func fetchDidSucceed() {
    }
    
    func fetchDidFail(with title: String, description: String) {
    }
}

//
//  URLProtocolMock.swift
//  SWAPIAppFakeTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

class URLProtocolStub: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        // Returning true means we will handle all requests
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Return test data immediately
        
    }
    
    override func stopLoading() {
    }
}

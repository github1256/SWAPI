//
//  URLProtocolMock.swift
//  SWAPIAppFakeTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

// Stub: Returns fixed data
class URLProtocolStub: URLProtocol {
    // Static property that maps URLs to data we expect
    static var testURLS = [URL?: Data]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        // Returning true means we will handle all requests
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Guard for valid URL and its test data
        guard let url = request.url,
            let safeData = URLProtocolStub.testURLS[url] else { return }
        // Return test data immediately
        client?.urlProtocol(self, didLoad: safeData)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}

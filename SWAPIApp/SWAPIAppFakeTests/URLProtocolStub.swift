//
//  URLProtocolMock.swift
//  SWAPIAppFakeTests
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

// Stub: Returns fixed data
final class URLProtocolStub: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        // Returning true means we will handle all url requests
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    static var requestHandler: ((URLRequest) -> (Data?, HTTPURLResponse, Error?))?
    
    override func startLoading() {
        guard let handler = URLProtocolStub.requestHandler else {
            fatalError("Request Handler is unavailable")
        }
        let (data, response, error) = handler(request)
        if let safeData = data {
            // Return test data immediately
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: safeData)
            client?.urlProtocolDidFinishLoading(self)
        } else if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Leave empty as this protocol is not asynchronous
    }
}

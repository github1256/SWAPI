//
//  NetworkError.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case request
    case decoding
    case network
    case unknown

    var reason: String {
        switch self {
        case .invalidUrl:
            return "Network Failure: Invalid URL"
        case .request:
            return "Network Failure: Error occurred while fetching data"
        case .decoding:
            return "Network Failure: Error occurred while decoding data"
        case .network:
            return "Network Failure: Unsuccessful HTTP response"
        case .unknown:
            return "Network Failure"
        }
    }
}

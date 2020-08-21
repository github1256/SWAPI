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
    case requestFailed(Error)
    case decodingFailed(Error)
    case unknown

    var reason: String {
        switch self {
        case .invalidUrl:
            return "Network Failure: Invalid URL"
        case .requestFailed:
            return "Network Failure: Failed to fetch data"
        case .decodingFailed:
            return "Network Failure: Failed to decode data"
        case .unknown:
            return "Network Failure"
        }
    }
}

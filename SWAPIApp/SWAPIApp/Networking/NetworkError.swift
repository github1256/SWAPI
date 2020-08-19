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
    case requestFailed
    case decodingFailed

    var reason: String {
        switch self {
        case .invalidUrl:
            return "Failed to fetch data from an invalid URL"
        case .requestFailed:
            return "Network Failure: Failed to fetch data"
        case .decodingFailed:
            return "Network Failure: Failed to decode data"
        }
    }
}

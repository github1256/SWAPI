//
//  NetworkError.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case requestFailed
    case decodingFailed
    
    var description: String {
        switch self {
        case .requestFailed:
            return "Failed to fetch data"
        case .decodingFailed:
            return "Failed to decode data"
        }
    }
}

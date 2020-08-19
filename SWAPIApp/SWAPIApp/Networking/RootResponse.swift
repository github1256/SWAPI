//
//  PagedResponse.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

struct RootResponse: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [People]
}

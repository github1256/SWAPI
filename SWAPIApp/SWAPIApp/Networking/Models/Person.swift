//
//  People.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-18.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

struct Person: Codable {
    let name: String
    let birthYear: String
    let eyeColor: String
    let gender: String
    let hairColor: String
    let height: String
    let mass: String
    let skinColor: String
    let homeworld: String
    let films: [URL]
    let species: [URL]
    let starships: [URL]
    let vehicles: [URL]
    let url: String
    let created: String
    let edited: String
}

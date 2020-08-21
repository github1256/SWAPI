//
//  Attributes.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-21.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import Foundation

enum Attributes: Int, CaseIterable {
    case height, mass, hairColor, skinColor, eyeColor, gender, films
    
    var title: String {
        switch self {
        case .height: return "Height (cm)"
        case .mass: return "Mass (kg)"
        case .hairColor: return "Hair Color"
        case .skinColor: return "Skin Color"
        case .eyeColor: return "Eye Color"
        case .gender: return "Gender"
        case .films: return "Films"
        }
    }
    
    static func getCount() -> Int {
        return self.allCases.count
    }

    static func getSection(_ section: Int) -> Attributes {
        return self.allCases[section]
    }
}

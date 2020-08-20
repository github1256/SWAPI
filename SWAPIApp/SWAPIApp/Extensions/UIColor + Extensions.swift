//
//  UIColor + Extensions.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

enum AssetsColor: String {
    case tintColor
}

extension UIColor {
    
    // MARK: - Flyweight Design Pattern
    // Returns cached objects if they exist, otherwise
    // creates a new instance.
    // Perhaps a bit of an overkill for this project,
    // but will be useful for additional custom colors.
    
    public static var colorStore: [String: UIColor] = [:]
    
    static func appColor(_ name: AssetsColor) -> UIColor? {
        let colorName = name.rawValue
        
        let key = "\(name)"
        if let color = colorStore[key] {
            return color
        }
        let color = UIColor(named: colorName)
        colorStore[key] = color
        return color
    }
    
}


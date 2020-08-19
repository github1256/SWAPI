//
//  String + Extensions.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension String {
    func customizeString(color: UIColor, fontSize: CGFloat, weight: UIFont.Weight) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes:
            [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: weight)
        ])
    }
}

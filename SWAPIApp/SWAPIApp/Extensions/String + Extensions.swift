//
//  String + Extensions.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension String {
    var wordCount: Int {
        var words: [Substring] = []
        self.enumerateSubstrings(in: self.startIndex...,
                                 options: .byWords) {
                                    (string, range, _, _) in
                                    words.append(self[range])
        }
        return words.count
    }
    
    func customizeString(color: UIColor, fontSize: CGFloat, weight: UIFont.Weight) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes:
            [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: weight)
        ])
    }
}

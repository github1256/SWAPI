//
//  String + Extensions.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

extension String {
    
    // Splits the string by words and returns the word count
    var wordCount: Int {
        var words: [String] = []
        self.enumerateSubstrings(in: self.startIndex...,
                                 options: .byWords) {
                                    (string, range, _, _) in
                                    if let string = string {
                                        words.append(string)
                                    }
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

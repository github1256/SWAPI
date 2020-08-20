//
//  CharacterCell.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-20.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.8941176471, blue: 0, alpha: 1)
        selectedBackgroundView = backgroundView
        
        textLabel?.textColor = isSelected ? .black : UIColor.label
    }
    
    // MARK: - Variables and Properties

    var person: Person! {
        didSet {
            textLabel?.text = person.name
        }
    }
}

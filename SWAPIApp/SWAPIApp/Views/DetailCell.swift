//
//  DetailCell.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-21.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    
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
    }
    
}

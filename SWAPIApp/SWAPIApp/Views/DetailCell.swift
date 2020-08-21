//
//  DetailCell.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-21.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Variables and Properties
    
    func configureCell(with text: String) {
        infoLabel?.text = text
    }

}

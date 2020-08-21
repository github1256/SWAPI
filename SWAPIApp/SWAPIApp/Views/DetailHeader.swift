//
//  DetailHeader.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-21.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class DetailHeader: UITableViewHeaderFooterView {
    
    var title = UILabel()
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        contentView.backgroundColor = UIColor.systemGray6
        contentView.addSubview(title)
        setupLayouts()
    }
    
    private func setupLayouts() {
        title.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 8))
    }
    
}

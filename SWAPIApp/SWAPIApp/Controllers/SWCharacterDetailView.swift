//
//  SWCharacterDetailView.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

class SWCharacterDetailView: UIViewController {
    
    // MARK: - Variables and Properties
    
    var person: Person! {
        didSet {
            view.backgroundColor = .white
            navigationItem.title = person.name
        }
    }
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

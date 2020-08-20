//
//  AlertService.swift
//  SWAPIApp
//
//  Created by Priscilla Ip on 2020-08-19.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

// Using a singleton pattern here,
// but UIViewController extension also works
class AlertService {
    private init() {}
    
    static func showAlert(title: String, message: String, on vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
}

//
//  ViewControllerExtensions.swift
//  Pokedex
//
//  Created by Lucas Daniel on 19/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

import UIKit
import SystemConfiguration

extension UIViewController {

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }    
}

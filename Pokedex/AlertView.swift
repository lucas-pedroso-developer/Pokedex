//
//  AlertView.swift
//  Pokedex
//
//  Created by Lucas Daniel on 10/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation
import UIKit

public final class AlertView {
    
    public static func showAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alert
    }
    
}

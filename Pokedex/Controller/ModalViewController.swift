//
//  ModalViewController.swift
//  Pokedex
//
//  Created by Lucas Daniel on 06/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    var abilityName: String?
    var abilityDescription: String? 
    
    @IBOutlet weak var abilityNameLabel: UILabel!
    @IBOutlet weak var abilityDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = abilityName {
            self.abilityNameLabel.text = name
        }
        
        if let description = abilityDescription {
            self.abilityDescriptionTextView.text = description
        }
        
    }
    

}

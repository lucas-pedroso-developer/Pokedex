//
//  AbilitiesDetail.swift
//  Pokedex
//
//  Created by Lucas Daniel on 06/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct AbilitiesDetail : Model {
    let flavor_text_entries : [Ability_Flavor_text_Entries]?
    
    public init(flavor_text_entries : [Ability_Flavor_text_Entries]?) {
        self.flavor_text_entries = flavor_text_entries
    }

}

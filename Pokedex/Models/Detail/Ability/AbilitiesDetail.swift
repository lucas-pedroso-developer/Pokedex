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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flavor_text_entries = try values.decodeIfPresent([Ability_Flavor_text_Entries].self, forKey: .flavor_text_entries)
    }

}

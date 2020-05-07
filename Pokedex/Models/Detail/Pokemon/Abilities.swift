//
//  Abilities.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Abilities : Model {
    let ability : Ability?
    let is_hidden : Bool?
    let slot : Int?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ability = try values.decodeIfPresent(Ability.self, forKey: .ability)
        is_hidden = try values.decodeIfPresent(Bool.self, forKey: .is_hidden)
        slot = try values.decodeIfPresent(Int.self, forKey: .slot)
    }

}

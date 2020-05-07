//
//  TypePokemon.swift
//  Pokedex
//
//  Created by Lucas Daniel on 06/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct TypePokemon : Model {
    let pokemon : Pokemon?
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pokemon = try values.decodeIfPresent(Pokemon.self, forKey: .pokemon)    
    }

}

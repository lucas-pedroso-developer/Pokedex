//
//  TypeDetail.swift
//  Pokedex
//
//  Created by Lucas Daniel on 06/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct TypeDetail : Model {
    let pokemon : [TypePokemon]?
        
    public init(pokemon: [TypePokemon]?) throws {
        self.pokemon = pokemon
    }

}

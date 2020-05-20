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
    
    public init(pokemon : Pokemon?) {
        self.pokemon = pokemon
    }

}

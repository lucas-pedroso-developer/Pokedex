//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Lucas Daniel on 29/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation


public struct PokemonDetail : Model {
    let id : Int?
    let name : String?
    let height : Int?
    let weight : Int?
    let stats : [Stats]?
    let abilities : [Abilities]?
    let types : [Types]?
    let species : Species?
    let sprites : Sprites?
        
    public init(id : Int?, name : String?, height : Int?, weight : Int?, stats : [Stats]?, abilities : [Abilities]?,
              types : [Types]?, species : Species?, sprites : Sprites?) {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.stats = stats
        self.abilities = abilities
        self.types = types
        self.species = species
        self.sprites = sprites
                
    }

}

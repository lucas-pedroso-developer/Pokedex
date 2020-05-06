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
        
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        weight = try values.decodeIfPresent(Int.self, forKey: .weight)
        stats = try values.decodeIfPresent([Stats].self, forKey: .stats)
        abilities = try values.decodeIfPresent([Abilities].self, forKey: .abilities)
        types = try values.decodeIfPresent([Types].self, forKey: .types)
        species = try values.decodeIfPresent(Species.self, forKey: .species)
        sprites = try values.decodeIfPresent(Sprites.self, forKey: .sprites)
                
    }

}

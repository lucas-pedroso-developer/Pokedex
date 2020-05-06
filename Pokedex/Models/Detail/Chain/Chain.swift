//
//  Chain.swift
//  Pokedex
//
//  Created by Lucas Daniel on 04/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Chain : Model {
    let evolves_to : [Evolves_to]?
    let species : Species?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        evolves_to = try values.decodeIfPresent([Evolves_to].self, forKey: .evolves_to)        
        species = try values.decodeIfPresent(Species.self, forKey: .species)
    }

}

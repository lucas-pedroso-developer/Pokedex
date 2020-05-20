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

    public init(evolves_to : [Evolves_to]?, species : Species?) {
        self.evolves_to = evolves_to
        self.species = species
    }

}

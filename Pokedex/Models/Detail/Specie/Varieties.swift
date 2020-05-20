//
//  Varieties.swift
//  Pokedex
//
//  Created by Lucas Daniel on 04/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation
public struct Varieties : Model {
    let is_default : Bool?
    let pokemon : Pokemon?

    public init(is_default : Bool?, pokemon : Pokemon?) {
        self.is_default = is_default
        self.pokemon = pokemon
    }

}

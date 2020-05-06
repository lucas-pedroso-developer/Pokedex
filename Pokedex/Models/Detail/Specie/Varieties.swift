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

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_default = try values.decodeIfPresent(Bool.self, forKey: .is_default)
        pokemon = try values.decodeIfPresent(Pokemon.self, forKey: .pokemon)
    }

}

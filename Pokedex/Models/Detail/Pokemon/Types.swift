//
//  Types.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Types : Model {
    let slot : Int?
    let type : Type?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slot = try values.decodeIfPresent(Int.self, forKey: .slot)
        type = try values.decodeIfPresent(Type.self, forKey: .type)
    }

}

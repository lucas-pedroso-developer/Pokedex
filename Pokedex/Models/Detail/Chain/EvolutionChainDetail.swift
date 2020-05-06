//
//  EvolutionChain.swift
//  Pokedex
//
//  Created by Lucas Daniel on 04/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct EvolutionChainDetail : Model {
    let baby_trigger_item : String?
    let chain : Chain?
    let id : Int?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        baby_trigger_item = try values.decodeIfPresent(String.self, forKey: .baby_trigger_item)
        chain = try values.decodeIfPresent(Chain.self, forKey: .chain)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

}

//
//  Stats.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Stats : Model {
    let base_stat : Int?
    let effort : Int?
    let stat : Stat?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base_stat = try values.decodeIfPresent(Int.self, forKey: .base_stat)
        effort = try values.decodeIfPresent(Int.self, forKey: .effort)
        stat = try values.decodeIfPresent(Stat.self, forKey: .stat)
    }

}

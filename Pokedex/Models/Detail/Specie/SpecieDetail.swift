//
//  SpecieDetail.swift
//  Pokedex
//
//  Created by Lucas Daniel on 04/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct SpecieDetail : Model {        
    let color : Color?
    let evolution_chain : Evolution_chain?
    let varieties : [Varieties]?
    let base_happiness : Int?
    let capture_rate : Int?
    let flavor_text_entries : [Flavor_text_entries]?
    
        
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        color = try values.decodeIfPresent(Color.self, forKey: .color)
        evolution_chain = try values.decodeIfPresent(Evolution_chain.self, forKey: .evolution_chain)
        varieties = try values.decodeIfPresent([Varieties].self, forKey: .varieties)
        base_happiness = try values.decodeIfPresent(Int.self, forKey: .base_happiness)
        capture_rate = try values.decodeIfPresent(Int.self, forKey: .capture_rate)
        flavor_text_entries = try values.decodeIfPresent([Flavor_text_entries].self, forKey: .flavor_text_entries)
    }
}

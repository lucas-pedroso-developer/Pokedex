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
    
        
    public init(color : Color?, evolution_chain : Evolution_chain?, varieties : [Varieties]?, base_happiness : Int?, capture_rate : Int?, flavor_text_entries : [Flavor_text_entries]?) {
        self.color = color
        self.evolution_chain = evolution_chain
        self.varieties = varieties
        self.base_happiness = base_happiness
        self.capture_rate = capture_rate
        self.flavor_text_entries = flavor_text_entries
    }
}

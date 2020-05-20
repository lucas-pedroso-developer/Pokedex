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

    public init(base_stat : Int?, effort : Int?, stat : Stat?) {
        self.base_stat = base_stat
        self.effort = effort
        self.stat = stat
    }

}

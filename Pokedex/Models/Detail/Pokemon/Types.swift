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

    public init(slot : Int?, type : Type?) {
        self.slot = slot
        self.type = type
    }

}

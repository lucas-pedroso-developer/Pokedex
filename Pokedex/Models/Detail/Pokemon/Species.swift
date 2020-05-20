//
//  Species.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Species : Model {
    let name : String?
    let url : String?

    public init(name : String?, url : String?) {
        self.name = name
        self.url = url
    }
}

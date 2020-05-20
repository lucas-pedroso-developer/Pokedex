//
//  Pokemons.swift
//  Pokedex
//
//  Created by Lucas Daniel on 28/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//
import Foundation

public struct Pokemons : Model {
    var count : Int?
    var next : String?
    var previous : String?
    var results : [Results]?

    public init(count: Int?, next: String, previous: String, results: [Results]?) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

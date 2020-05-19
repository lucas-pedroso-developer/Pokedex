//
//  PokemonParser.swift
//  Pokedex
//
//  Created by Lucas Daniel on 17/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct PokemonsParser : Model {
    let count : Int?
    let next : String?
    let previous : String?
    let results : [ResultsParser]?

    enum CodingKeys: String, CodingKey {

        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        next = try values.decodeIfPresent(String.self, forKey: .next)
        previous = try values.decodeIfPresent(String.self, forKey: .previous)
        results = try values.decodeIfPresent([ResultsParser].self, forKey: .results)
    }

}

public struct ResultsParser : Model {
    let name : String?
    let url : String?
        
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

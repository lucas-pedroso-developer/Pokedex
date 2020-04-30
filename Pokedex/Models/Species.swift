//
//  Species.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

struct Species : Model {
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

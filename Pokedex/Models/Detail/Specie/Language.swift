//
//  Language.swift
//  Pokedex
//
//  Created by Lucas Daniel on 05/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

struct Language : Model {
    let name : String?
    let url : String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

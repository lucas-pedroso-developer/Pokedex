//
//  Version_group.swift
//  Pokedex
//
//  Created by Lucas Daniel on 06/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Version_group : Model {
    let name : String?
    let url : String?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

//
//  Flavor_text_entries.swift
//  Pokedex
//
//  Created by Lucas Daniel on 05/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Flavor_text_entries : Model {
    let flavor_text : String?
    let language : Language?
    let version : Version?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flavor_text = try values.decodeIfPresent(String.self, forKey: .flavor_text)
        language = try values.decodeIfPresent(Language.self, forKey: .language)
        version = try values.decodeIfPresent(Version.self, forKey: .version)
    }

}

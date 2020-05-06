//
//  Flavor_Text_Entries.swift
//  Pokedex
//
//  Created by Lucas Daniel on 06/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Ability_Flavor_text_Entries : Model {
    let flavor_text : String?
    let language : Language?
    let version_group : Version_group?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flavor_text = try values.decodeIfPresent(String.self, forKey: .flavor_text)
        language = try values.decodeIfPresent(Language.self, forKey: .language)
        version_group = try values.decodeIfPresent(Version_group.self, forKey: .version_group)
    }

}

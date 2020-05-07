//
//  Sprites.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Sprites : Model {
    let back_default : String?
    let back_female : String?
    let back_shiny : String?
    let back_shiny_female : String?
    let front_default : String?
    let front_female : String?
    let front_shiny : String?
    let front_shiny_female : String?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        back_default = try values.decodeIfPresent(String.self, forKey: .back_default)
        back_female = try values.decodeIfPresent(String.self, forKey: .back_female)
        back_shiny = try values.decodeIfPresent(String.self, forKey: .back_shiny)
        back_shiny_female = try values.decodeIfPresent(String.self, forKey: .back_shiny_female)
        front_default = try values.decodeIfPresent(String.self, forKey: .front_default)
        front_female = try values.decodeIfPresent(String.self, forKey: .front_female)
        front_shiny = try values.decodeIfPresent(String.self, forKey: .front_shiny)
        front_shiny_female = try values.decodeIfPresent(String.self, forKey: .front_shiny_female)
    }

}
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

    public init(flavor_text : String?, language : Language?, version : Version?)  {
        self.flavor_text = flavor_text
        self.language = language
        self.version = version
    }

}

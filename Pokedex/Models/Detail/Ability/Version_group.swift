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

    public init(name : String?, url : String?) throws {
        self.name = name
        self.url = url
    }

}

//
//  Results.swift
//  Pokedex
//
//  Created by Lucas Daniel on 20/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public struct Results : Model {
    let name : String?
    let url : String?
       
    public init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }

}

//
//  Model.swift
//  Pokedex
//
//  Created by Lucas Daniel on 28/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public protocol Model: Encodable, Decodable, Equatable {
    
}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}


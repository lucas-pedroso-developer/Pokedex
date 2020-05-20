//
//  DataExtension.swift
//  Pokedex
//
//  Created by Lucas Daniel on 20/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
    
    //caso for serializar, não usarei por enquanto
    func toJson() -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
    }
}

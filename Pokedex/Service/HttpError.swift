//
//  HttpError.swift
//  Pokedex
//
//  Created by Lucas Daniel on 29/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}

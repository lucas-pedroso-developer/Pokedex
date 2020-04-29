//
//  PokedexService.swift
//  Pokedex
//
//  Created by Lucas Daniel on 28/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation
import Alamofire

public class PokedexService {
    let baseURL = "https://pokeapi.co/api/v2/pokemon"    
    func getAllPokemons(url: String, completion: @escaping (Result<Pokemons?, HttpError>) -> ()) {
        AF.request(url, method: .get).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                    case 204:
                        completion(.success(nil))
                    case 200...299:
                        let decoder = JSONDecoder()
                        let data = response.data
                        do {
                            if let dataFromJSON = data {
                                let result = try decoder.decode(Pokemons.self, from: dataFromJSON)
                                completion(.success(result))
                            }
                        } catch {
                            completion(.failure(.noConnectivity))
                        }
                    case 401:
                        completion(.failure(.unauthorized))
                    case 403:
                        completion(.failure(.forbidden))
                    case 400...499:
                        completion(.failure(.badRequest))
                    case 500...599:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.noConnectivity))
                }
            }
        }
    }
}


/*public class PokedexService {
    let baseURL = "https://pokeapi.co/api/v2/pokemon"
    //let base url = "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20"
    //func getAllPokemons(completion: @escaping (Pokemons?) -> ()) {
    //func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void)
    //(Result<Data?, HttpError>)
    func getAllPokemons(url: String, completion: @escaping (Result<Pokemons?, HttpError>) -> ()) {
        AF.request(url, method: .get).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                    case 204:
                        completion(.success(nil))
                    case 200...299:
                        let decoder = JSONDecoder()
                        let data = response.data
                        do {
                            if let dataFromJSON = data {
                                let result = try decoder.decode(Pokemons.self, from: dataFromJSON)
                                completion(.success(result))
                            }
                        } catch {
                            completion(.failure(.noConnectivity))
                        }
                    case 401:
                        completion(.failure(.unauthorized))
                    case 403:
                        completion(.failure(.forbidden))
                    case 400...499:
                        completion(.failure(.badRequest))
                    case 500...599:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.noConnectivity))
                }
            }
        }
    }
}*/

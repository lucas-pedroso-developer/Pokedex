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
        
    //Refatorar para um método retornando Data?
    
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
    
    func getPokemonDetail(url: String, completion: @escaping (Result<PokemonDetail?, HttpError>) -> ()) {
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
                                let result = try decoder.decode(PokemonDetail.self, from: dataFromJSON)
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
    
    func getPokemonSpecie(url: String, completion: @escaping (Result<SpecieDetail?, HttpError>) -> ()) {
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
                                let result = try decoder.decode(SpecieDetail.self, from: dataFromJSON)
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
    
    func getPokemonEvolution(url: String, completion: @escaping (Result<EvolutionChainDetail?, HttpError>) -> ()) {
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
                                let result = try decoder.decode(EvolutionChainDetail.self, from: dataFromJSON)
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
    
    func getPokemonAbilities(url: String, completion: @escaping (Result<AbilitiesDetail?, HttpError>) -> ()) {
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
                                let result = try decoder.decode(AbilitiesDetail.self, from: dataFromJSON)
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
    
    func getPokemonTypes(url: String, completion: @escaping (Result<TypeDetail?, HttpError>) -> ()) {
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
                                let result = try decoder.decode(TypeDetail.self, from: dataFromJSON)
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

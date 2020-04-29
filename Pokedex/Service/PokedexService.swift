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
    
    let baseURL = "https://pokeapi.co/api/v2/"
        
    //func getMovies(completion: @escaping (MoviesBase?)->()) {
    func getAllPokemons(completion: @escaping (Pokemons?) -> ()) {
        AF.request("https://pokeapi.co/api/v2/pokemon?offset=20&limit=20", method: .get).responseJSON { response in
           // print(response)
            
            //if let status = response.response?.statusCode {
                /*switch(status){
                case 201:*/
                    let decoder = JSONDecoder()
                    let data = response.data
                    do {
                        if let dataFromJSON = data {
                            print(dataFromJSON)
                            let result = try decoder.decode(Pokemons.self, from: dataFromJSON)
                                completion(result)
                            }
                    } catch {
                        completion(nil)
                    }
                /*default:
                    print("error with response status: \(status)")
                }*/
            //}
            
            print(response.result)
            
            //to get JSON return value
            /*if let result = response.result {
                let JSON = result as! NSDictionary
                print(JSON)
            }*/
            
            //completion(response)
            /*guard response.result.isSuccess else {
                print("Ошибка при запросе данных\(String(describing: response.result.error))")
                return
            }
            guard let arrayOfItems = response.result.value as? [[String:AnyObject]]
                else {
                    print("Не могу перевести в массив")
                    return
            }
            for itm in arrayOfItems {
                let item = Item(albimID: itm["albumId"] as! Int, id: itm["id"] as! Int, title: itm["title"] as! String, url: itm["url"] as! String)
                self.items.append(item)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }*/
        }
    }
    
    
    /*func getMovies(completion: @escaping (MoviesBase?)->()) {
        
        Alamofire.request(URLs.baseURL, headers: headers)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(_ ):
                    
                    let decoder = JSONDecoder()
                    let data = response.data
                    
                    do {
                        
                    if let dataFromJSON = data {
                        print(dataFromJSON)
                        let result = try decoder.decode(MoviesBase.self, from: dataFromJSON)
                            completion(result)
                        }
                        
                    } catch {
                        completion(nil)
                    }
                    
                case .failure(let error):
                    completion(nil)
                }
        }
    }*/
     
    
    
    /*public func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return
                completion(.failure(.noConnectivity)) }
            switch dataResponse.result {
                case .failure: completion(.failure(.noConnectivity))
                case .success(let data):
                    switch statusCode {
                    case 204:
                        completion(.success(nil))
                    case 200...299:
                        completion(.success(data))
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
    }*/
    
}

//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var id: Int = 0
    var pokemon: PokemonDetail?
    let service = PokedexService()
    var api_url = "https://pokeapi.co/api/v2/pokemon"
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var pokemonIdLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var atackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAtackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getPokemon(url: "https://pokeapi.co/api/v2/pokemon/\(self.id)")

    }
    
    func getPokemon(url: String) {
        service.getPokemonDetail(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.pokemon = data
                    let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.id).png")!
                    let data = try? Data(contentsOf: url)
                    self.pokemonImageView.image = UIImage(data: data!)
                                        
                    let stats = self.pokemon?.stats
                    let abilities = self.pokemon?.abilities
                    let types = self.pokemon?.types
                    
                    for stat in stats! {
                        let name = stat.stat?.name!
                        
                        if (name?.elementsEqual("hp"))! {
                            if let base_stat = stat.base_stat {
                                self.hpLabel.text = "\(base_stat)"
                            }
                        } else if (name?.elementsEqual("defense"))! {
                            if let base_stat = stat.base_stat {
                                self.atackLabel.text = "\(base_stat)"
                            }
                        } else if (name?.elementsEqual("attack"))! {
                            if let base_stat = stat.base_stat {
                                self.defenseLabel.text = "\(base_stat)"
                            }
                        } else if (name?.elementsEqual("special-attack"))! {
                            if let base_stat = stat.base_stat {
                                self.specialAtackLabel.text = "\(base_stat)"
                            }
                        } else if (name?.elementsEqual("special-defense"))! {
                            if let base_stat = stat.base_stat {
                                self.specialDefenseLabel.text = "\(base_stat)"
                            }
                        } else if (name?.elementsEqual("speed"))! {
                            if let base_stat = stat.base_stat {
                                self.speedLabel.text = "\(base_stat)"
                            }
                        } else {
                            print("Erro nos status")
                        }
                        
                        /*switch name {
                        case "hp":
                            print()
                            self.hpLabel.text = String(stat.base_stat!)
                            break
                        case "defense":
                            self.atackLabel.text = "\(stat.base_stat)"
                            break
                        case "atack":
                            self.defenseLabel.text = "\(stat.base_stat)"
                            break
                        case "special-attack":
                            self.specialAtackLabel.text = "\(stat.base_stat)"
                            break
                        case "special-defense":
                            self.specialDefenseLabel.text = "\(stat.base_stat)"
                            break
                        case "speed":
                            self.speedLabel.text = "\(stat.base_stat)"
                            break
                        
                        default:
                            print("erro")
                            break
                        }*/
                    }
                    
                    self.abilityLabel.text = "Habilidades:"
                    for ability in abilities! {
                        if let name = ability.ability?.name {
                            self.abilityLabel.text! += " " + name + ","
                        }
                    }
                    self.abilityLabel.text?.removeLast()
                    
                    self.typeLabel.text = "Tipo:"
                    for type in types! {
                        if let name = type.type?.name {
                            self.typeLabel.text! += " " + name + ","
                        }
                    }
                    self.typeLabel.text?.removeLast()
                    
                    /*"types": [
                        {
                            "slot": 2,
                            "type": {
                                "name": "poison",
                                "url": "https://pokeapi.co/api/v2/type/4/"
                            }
                        },
                        {
                            "slot": 1,
                            "type": {
                                "name": "grass",
                                "url": "https://pokeapi.co/api/v2/type/12/"
                            }
                        }
                    ],*/
                    
                    
                } else {
                    print("Não foi retornado nenhum Pokemon")
                }
            case .failure(let error):
                print(error)
                print("erro")
            }
        }
    }

}

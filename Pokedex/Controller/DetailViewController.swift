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

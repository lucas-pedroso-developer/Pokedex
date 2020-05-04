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
    var types: [Types]?
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
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
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var pokemonImageBackgroundView: UIView!
    @IBOutlet weak var pokemonImageBackgroundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pokemonImageBackgroundViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var statusView: UIView!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        
        pokemonImageBackgroundViewHeight.constant = self.view.bounds.height*24/100
        pokemonImageBackgroundViewWidth.constant = self.view.bounds.height*24/100
        pokemonImageBackgroundView.layer.cornerRadius = self.view.bounds.height*12/100
                        
        self.whiteBackgroundView.layer.cornerRadius = self.view.bounds.height*4/100
        self.whiteBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        
        getPokemon(url: "https://pokeapi.co/api/v2/pokemon/\(self.id)")

    }
    
    func getPokemon(url: String) {
        service.getPokemonDetail(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.pokemon = data
                    self.setPokemonImage()
                    self.setPokemonData()
                    self.setPokemonStatus()
                    self.setPokemonAbilities()
                    self.setPokemonTypes()
                } else {
                    print("Não foi retornado nenhum Pokemon")
                }
            case .failure(let error):
                print(error)
                print("erro")
            }
        }
    }
    
    private func setPokemonImage() {
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.id).png")!
        let data = try? Data(contentsOf: url)
        self.pokemonImageView.image = UIImage(data: data!)
    }
    
    private func setPokemonData() {
        if let id = self.pokemon?.id {
            self.pokemonIdLabel.text = "\(id)"
        }
        
        if let height = self.pokemon?.height {
            self.heightLabel.text = "\(height)"
        }
        
        if let weight = self.pokemon?.weight {
            self.weightLabel.text = "\(weight)"
        }
    }
    
    private func setPokemonStatus() {
        let stats = self.pokemon?.stats
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
        }
    }
    
    private func setPokemonAbilities() {
        let abilities = self.pokemon?.abilities
        self.abilityLabel.text = ""
        for ability in abilities! {
            if let name = ability.ability?.name {
                self.abilityLabel.text! += name + ", "
            }
        }
        self.abilityLabel.text?.removeLast()
        self.abilityLabel.text?.removeLast()
    }
    
    private func setPokemonTypes() {
        self.types = self.pokemon?.types
        self.typeCollectionView.reloadData()
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favorite(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func change(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.dataView.isHidden = false
            self.statusView.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.dataView.isHidden = true
            self.statusView.isHidden = false
        } else if sender.selectedSegmentIndex == 2 {
            self.dataView.isHidden = true
            self.statusView.isHidden = true
        }
    }
    
}

class TypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var typeLabel: UILabel!
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.types != nil {
            return self.types?.count ?? 0
        }
        return 0
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cell", for: indexPath as IndexPath) as! TypeCollectionViewCell
        cell.typeLabel.text = self.types?[indexPath.item].type?.name
        cell.typeLabel.layer.cornerRadius = collectionView.contentSize.width*11/100
        return cell
    }
}

/*
Normal Type: A8A77A
Fire Type:  EE8130
Water Type:  6390F0
Electric Type:  F7D02C
Grass Type:  7AC74C
Ice Type:  96D9D6
Fighting Type:  C22E28
Poison Type:  A33EA1
Ground Type:  E2BF65
Flying Type:  A98FF3
Psychic Type:  F95587
Bug Type:  A6B91A
Rock Type:  B6A136
Ghost Type:  735797
Dragon Type:  6F35FC
Dark Type:  705746
Steel Type:  B7B7CE
Fairy Type:  D685AD
*/

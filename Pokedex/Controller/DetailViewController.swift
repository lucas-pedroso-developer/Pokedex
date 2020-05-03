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
                    let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.id).png")!
                    let data = try? Data(contentsOf: url)
                    self.pokemonImageView.image = UIImage(data: data!)
                                        
                    if let id = self.pokemon?.id {
                        self.pokemonIdLabel.text = "\(id)"
                    }
                    
                    if let height = self.pokemon?.height {
                        self.heightLabel.text = "\(height)"
                    }
                    
                    if let weight = self.pokemon?.weight {
                        self.weightLabel.text = "\(weight)"
                    }
                    
                    /*self.heightLabel.text = "\(self.pokemon?.height!)"
                    self.weightLabel.text = "\(self.pokemon?.weight!)"*/
                    
                    let stats = self.pokemon?.stats
                    let abilities = self.pokemon?.abilities
                    self.types = self.pokemon?.types
                    
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
                    self.abilityLabel.text = ""
                    for ability in abilities! {
                        if let name = ability.ability?.name {
                            self.abilityLabel.text! += name + ", "
                        }
                    }
                    self.abilityLabel.text?.removeLast()
                    self.abilityLabel.text?.removeLast()
                    
                    /*self.typeLabel.text = "Tipo:"
                    for type in self.types! {
                        if let name = type.type?.name {
                            self.typeLabel.text! += " " + name + ","
                        }
                    }
                    self.typeLabel.text?.removeLast()*/
                    
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
                    
                    self.typeCollectionView.reloadData()
                    
                } else {
                    print("Não foi retornado nenhum Pokemon")
                }
            case .failure(let error):
                print(error)
                print("erro")
            }
        }
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
        
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        //return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
        return CGSize(width: collectionView.contentSize.width*20/100, height: collectionView.contentSize.height*10/100)
    }*/
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cell", for: indexPath as IndexPath) as! TypeCollectionViewCell
                        
        cell.typeLabel.text = self.types?[indexPath.item].type?.name
        
        cell.typeLabel.layer.cornerRadius = collectionView.contentSize.width*11/100
        /*cell.layer.shadowColor = UIColor.darkGray
        cell.layer.shado
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1*/
        
        

        return cell
    }
            
}

//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit

class EvolutionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

class DetailViewController: UIViewController {

    var id: Int = 0
    var pokemon: PokemonDetail?
    var specie: SpecieDetail?
    var evolutionChain: EvolutionChainDetail?
    var ability: AbilitiesDetail?
    var type: TypeDetail?
    
    let service = PokedexService()
    var api_url = "https://pokeapi.co/api/v2/pokemon"
    var types: [Types]?
    var pokemonArray: [Int: String] = [:]
    
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
        
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var evolutionCollectionView: UICollectionView!
    @IBOutlet weak var abilitiesCollectionView: UICollectionView!
    
        
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var pokemonImageBackgroundView: UIView!
    @IBOutlet weak var pokemonImageBackgroundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pokemonImageBackgroundViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var evolutionView: UIView!
    
    @IBOutlet weak var typeColorBackgroundView: UIView!
    
    @IBOutlet weak var backNavBarButton: UIBarButtonItem!
    @IBOutlet weak var favoriteNavBarButton: UIBarButtonItem!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dataDescriptionLabel: UILabel!
    
    @IBOutlet weak var pokemonActualLabel: UILabel!
    @IBOutlet weak var pokemonEvolutionLabel: UILabel!
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var abilityModalNameLabel: UILabel!
    @IBOutlet weak var abilityModalDescriptionTextView: UITextView!
    @IBOutlet weak var abilityModalCloseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        
        abilitiesCollectionView.delegate = self
        abilitiesCollectionView.dataSource = self
        
        pokemonImageBackgroundViewHeight.constant = self.view.bounds.height*24/100
        pokemonImageBackgroundViewWidth.constant = self.view.bounds.height*24/100
        pokemonImageBackgroundView.layer.cornerRadius = self.view.bounds.height*12/100
                        
        self.whiteBackgroundView.layer.cornerRadius = self.view.bounds.height*4/100
        self.whiteBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.modalView.layer.cornerRadius = self.view.bounds.height*4/100
        self.modalView.layer.cornerRadius = self.view.bounds.height*4/100
                
        let urlPokeApi = "https://pokeapi.co/api/v2/pokemon/\(self.id)"
        
        self.abilityLabel.layer.cornerRadius = self.view.bounds.height*2/100
        self.dataDescriptionLabel.layer.cornerRadius = self.view.bounds.height*2/100
        
        
        self.segment.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
        getPokemon(url: urlPokeApi)
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
                    if let specieUrl = self.pokemon?.species?.url {
                        self.getSpecie(url: specieUrl)
                    }
                } else {
                    print("Não foi retornado nenhum Pokemon")
                }
            case .failure(let error):
                print(error)
                print("erro")
            }
        }
    }
    
    func getSpecie(url: String) {
        service.getPokemonSpecie(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.specie = data
                    
                    if let flavor_text_entries = self.specie?.flavor_text_entries {
                        for flavor in flavor_text_entries {
                            if (flavor.language?.name?.elementsEqual("en"))! && ((flavor.language?.name?.elementsEqual("alpha-sapphire")) != nil) {
                                if let text = flavor.flavor_text {
                                    //self.descriptionLabel.text = flavor.flavor_text
                                    self.descriptionLabel.text = flavor.flavor_text?.replacingOccurrences(of: "\n", with: " ")
                                }
                            }
                        }
                    }
                        
                    /*print(self.specie?.evolution_chain?.url)
                    if let url = self.specie?.evolution_chain?.url {
                        self.getPokemonEvolution(url: url)
                    }*/
                    
                    print(self.specie?.evolution_chain?.url)
                    if let url = self.specie?.evolution_chain?.url {
                        self.getPokemonEvolution(url: url)
                    }
                } else {
                    print("Não foi retornado nenhum dado")
                }
            case .failure(let error):
                print(error)
                print("erro")
            }
        }
    }
            
    func getPokemonEvolution(url: String) {
        service.getPokemonEvolution(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.evolutionChain = data
                    self.pokemonActualLabel.text = self.evolutionChain?.chain?.species?.name //atual
                    self.pokemonEvolutionLabel.text = self.evolutionChain?.chain?.evolves_to?[0].species?.name //proximo
                    
                    /*print(self.evolutionChain?.chain?.species?.name) //1 - bulbassauro
                    print(self.evolutionChain?.chain?.evolves_to?[0].species?.name) //2 - ivyssauro
                    print(self.evolutionChain?.chain?.evolves_to?[0].evolves_to?[0].species?.name) // - venussauro*/
                    
                    /*print(self.evolutionChain?.chain?.species)
                    print(self.evolutionChain?.chain?.evolves_to)
                    //print(self.evolutionChain?.chain?.species?.name) //1 - bulbassauro
                    print(self.evolutionChain?.chain?.evolves_to?.count)
                    
                    print(self.evolutionChain?.chain?.evolves_to?[0].evolves_to?.count)
                    
                    
                     
                    while true {
                        if
                    }*/
                    
                    
                    /*if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                        if let to = evolutions[0]["to"] as? String {
                            //Mega evolutions not supported right now
                            if to.range(of: "mega") == nil {
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                        
                                    let num = newStr.replacingOccurrences(of: "/", with: "")
                                        
                                    self._nextEvolutionID = num
                                    self._nextEvolutionText = to
                                        
                                    if let level = evolutions[0]["level"] as? Int {
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                        
                                    print(self._nextEvolutionID)
                                    print(self._nextEvolutionText)
                                    if self._nextEvolutionLevel != nil {
                                            print(self._nextEvolutionLevel)
                                    }
                                }
                            }
                        }
                    }*/
                    
                    
                    
                    var tes = true
                    var counter = 0
                    
                    /*while tes {
                        self.evolutionSpecieArray.append(((self.evolutionChain?.chain?.evolves_to?[counter])?.species as! EvolutionSpecie))
                        counter += 1
                        if self.evolutionChain?.chain?.evolves_to!.isEmpty {
                            tes = false
                        }
                    }*/
                    
                    
                } else {
                    print("Não foi retornado nenhum dado")
                }
            case .failure(let error):
                print(error)
                print("erro")
            }
        }
    }
    
    func getAbilities(url: String, index: Int) {
        service.getPokemonAbilities(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.ability = data
                    
                    if let flavor_text_entries = self.ability?.flavor_text_entries {
                        for flavor in flavor_text_entries {
                            print(flavor.language?.name)
                            print()
                            if (flavor.language?.name?.elementsEqual("en"))! && ((flavor.version_group?.name?.elementsEqual("omega-ruby-alpha-sapphire")) != nil) {
                                if let text = flavor.flavor_text {
                                    self.abilityModalNameLabel.text = self.pokemon?.abilities?[index].ability?.name
                                    self.abilityModalDescriptionTextView.text = text.replacingOccurrences(of: "\n", with: " ")
                                    self.showHideModal(show: true)
                                    break
                                    /*let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
                                    
                                    newViewController.abilityName = self.pokemon?.abilities?[index].ability?.name
                                    newViewController.abilityDescription = text
                                    
                                    newViewController.modalPresentationStyle = UIModalPresentationStyle.popover
                                    newViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                    
                                                
                                    self.present(newViewController, animated: true, completion: nil)*/
                                    
                                    
                                    //self.descriptionLabel.text = flavor.flavor_text?.replacingOccurrences(of: "\n", with: " ")
                                }
                            }
                        }
                    }
                                                            
                    
                } else {
                    print("Não foi retornado nenhum dado")
                }
            case .failure(let error):
                print(error)
                print("erro")
            }
        }
    }
    
    func getTypesPokemon(url: String, index: Int) {
        service.getPokemonTypes(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    print(self.type)
                    self.type = data
                                        
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TypeViewController") as! TypeViewController
                    
                    newViewController.type  = self.type
                    newViewController.pokemonType = (self.types?[index].type?.name)! //UIColor(named: (self.types?[indexPath.item].type?.name)!)
                                        
                    newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    newViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                                
                    self.present(newViewController, animated: true, completion: nil)
                    
                    
                    
                }
            case .failure(let error):
                print(error)
                print("erro")
            
            }
        }
    }
            
    
    
    private func setPokemonImage() {
        /*let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.id).png")!*/
                
        let url = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(String(format: "%03d", id)).png")!
        
        let data = try? Data(contentsOf: url)
        self.pokemonImageView.image = UIImage(data: data!)
    }
    
    private func setPokemonData() {
        if let name = self.pokemon?.name {
            self.pokemonNameLabel.text = name
        }
        
        if let id = self.pokemon?.id {
            self.pokemonIdLabel.text = "# \(id)"
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
        /*let abilities = self.pokemon?.abilities
        self.abilityLabel.text = ""
        for ability in abilities! {
            if let name = ability.ability?.name {
                self.abilityLabel.text! += name + ", "
            }
        }
        self.abilityLabel.text?.removeLast()
        self.abilityLabel.text?.removeLast()*/
        
        let abilities = self.pokemon?.abilities
        self.abilitiesCollectionView.reloadData()
    }
    
    private func setPokemonTypes() {
        self.types = self.pokemon?.types
        self.typeCollectionView.reloadData()
    }
    
    func showHideModal(show: Bool) {
        self.shadowView.isHidden = !show
        self.modalView.isHidden = !show
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
            self.evolutionView.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.dataView.isHidden = true
            self.statusView.isHidden = false
            self.evolutionView.isHidden = true
        } else if sender.selectedSegmentIndex == 2 {
            self.dataView.isHidden = true
            self.statusView.isHidden = true
            self.evolutionView.isHidden = false
        }
    }
    
    @IBAction func showAbilityDescription(_ sender: UIButton) {
        print(self.pokemon?.abilities?[sender.tag].ability?.name)
        print(self.pokemon?.abilities?[sender.tag].ability?.url)
        if let url = self.pokemon?.abilities?[sender.tag].ability?.url {
            self.getAbilities(url: url, index: sender.tag)
        }
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.showHideModal(show: false)
    }
    
    @IBAction func showPokemonTypes(_ sender: UIButton) {
        if let url = self.pokemon?.types?[sender.tag].type?.url {
            self.getTypesPokemon(url: url, index: sender.tag)
        }
    }
    
    
}

class TypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var typeButton: UIButton!
}

class AbilitiesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var abilityButton: UIButton!
    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        if collectionView.tag == 0 {
            if self.types != nil {
                return self.types?.count ?? 0
            }
        } else if collectionView.tag == 1 {
            if self.evolutionChain != nil {
                return 1
            }
        } else if collectionView.tag == 2 {
            if self.pokemon?.abilities != nil {
                return self.pokemon?.abilities?.count ?? 0
            }
        }
        
        return 0
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cell", for: indexPath as IndexPath) as! TypeCollectionViewCell
            cell.typeButton.setTitle(self.types?[indexPath.item].type?.name, for: .normal)
            cell.typeButton.tag = indexPath.item
            self.typeColorBackgroundView.backgroundColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            cell.backgroundColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = self.view.bounds.width*4/100
            self.backNavBarButton.tintColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            self.favoriteNavBarButton.tintColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            self.segment.backgroundColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            self.abilityLabel.backgroundColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            self.dataDescriptionLabel.backgroundColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "evolutionCell", for: indexPath as IndexPath) as! EvolutionCollectionViewCell
            cell.nameLabel.text = self.evolutionChain?.chain?.evolves_to?[indexPath.item].species?.name!
            return cell
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "abilityCell", for: indexPath as IndexPath) as! AbilitiesCollectionViewCell
            cell.abilityButton.setTitle(self.pokemon?.abilities?[indexPath.item].ability?.name, for: .normal)
            cell.abilityButton.tag = indexPath.item
            cell.backgroundColor = .clear
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = self.view.bounds.width*4/100
            return cell
        }        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        if collectionView.tag == 0 {
            return CGSize(width: self.view.bounds.width*20/100, height: self.view.bounds.height*5/100)
        } else if collectionView.tag == 1 {
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
        } else if collectionView.tag == 2 {
            return CGSize(width: self.view.bounds.width*30/100, height: self.view.bounds.height*4/100)
        }
        return CGSize(width: 0, height: 0)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            let newViewController = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
            
            newViewController.abilityName = self.pokemon?.abilities?[indexPath.item].ability?.name
            newViewController.abilityDescription = self.pokemon?.abilities?[indexPath.item].ability?.name
            
            newViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            newViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        
            present(newViewController, animated: true, completion: nil)
        }
    }*/
    
    
}

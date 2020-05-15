//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Lucas Daniel on 30/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit
import RSLoadingView
import ImageSlideshow

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
    var types: [Types]?
    var pokemonArray: [Int: String] = [:]
    var speciesEvolutionArray: [Species] = []
    var api_url = "https://pokeapi.co/api/v2/pokemon"
    var pokemonMainColor: UIColor?
    
    var specieEvolution: [Chain]?
    
    let service = PokedexService()
    let decoder = JSONDecoder()
    
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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dataDescriptionLabel: UILabel!
    
    @IBOutlet weak var pokemonActualLabel: UILabel!
    @IBOutlet weak var pokemonEvolutionLabel: UILabel!
        
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var abilityModalNameLabel: UILabel!
    @IBOutlet weak var abilityModalDescriptionTextView: UITextView!
    @IBOutlet weak var abilityModalCloseButton: UIButton!
    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var spritesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        
        abilitiesCollectionView.delegate = self
        abilitiesCollectionView.dataSource = self
        
        evolutionCollectionView.delegate = self
        evolutionCollectionView.dataSource = self
        
        pokemonImageBackgroundViewHeight.constant = self.view.bounds.height*24/100
        pokemonImageBackgroundViewWidth.constant = self.view.bounds.height*24/100
        pokemonImageBackgroundView.layer.cornerRadius = self.view.bounds.height*12/100
                        
        self.whiteBackgroundView.layer.cornerRadius = self.view.bounds.height*4/100
        self.whiteBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.modalView.layer.cornerRadius = self.view.bounds.height*4/100
        self.modalView.layer.cornerRadius = self.view.bounds.height*4/100
                
        let urlPokeApi = "https://pokeapi.co/api/v2/pokemon/\(self.id)"
        
        self.abilityLabel.layer.cornerRadius = self.view.bounds.height*1/100
        self.dataDescriptionLabel.layer.cornerRadius = self.view.bounds.height*1/100
        self.spritesLabel.layer.cornerRadius = self.view.bounds.height*1/100
        
        self.segment.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
        self.configureBackGesture()
        
        
        getPokemon(url: urlPokeApi)
    }
                      
    func getPokemon(url: String) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    do {
                        if let dataFromJSON = data {
                            self.pokemon = try self.decoder.decode(PokemonDetail.self, from: dataFromJSON)
                        }
                    } catch {
                        let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado o Pokemon")
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.setPokemonImage()
                    self.setPokemonData()
                    self.setPokemonStatus()
                    self.setPokemonAbilities()
                    self.setPokemonTypes()
                    if let specieUrl = self.pokemon?.species?.url {
                        self.getSpecie(url: specieUrl)
                    }
                } else {
                    let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = AlertView.showAlert(title: "Erro", message:"Ocorreu um erro, tente mais tarde novamente")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
    func getSpecie(url: String) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    do {
                        if let dataFromJSON = data {
                            self.specie = try self.decoder.decode(SpecieDetail.self, from: dataFromJSON)
                        }
                    } catch {
                        let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                        self.present(alert, animated: true, completion: nil)
                    }                                                            
                    
                    if let flavor_text_entries = self.specie?.flavor_text_entries {
                        for flavor in flavor_text_entries {
                            if (flavor.language?.name?.elementsEqual("en"))! && ((flavor.language?.name?.elementsEqual("alpha-sapphire")) != nil) {
                                if let text = flavor.flavor_text {
                                    self.descriptionLabel.text = flavor.flavor_text?.replacingOccurrences(of: "\n", with: " ")
                                }
                            }
                        }
                    }
                                        
                    if let url = self.specie?.evolution_chain?.url {
                        self.getPokemonEvolution(url: url)
                    }
                } else {
                    let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = AlertView.showAlert(title: "Erro", message:"Ocorreu um erro, tente mais tarde novamente")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
         
    func getPokemonEvolution(url: String) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    do {
                        if let dataFromJSON = data {
                            self.evolutionChain = try self.decoder.decode(EvolutionChainDetail.self, from: dataFromJSON)
                        }
                    } catch {
                        let alert = AlertView.showAlert(title: "Aviso", message:"Este pokemon não tem evolução!")
                        self.present(alert, animated: true, completion: nil)
                    }
                    if let evolves = self.evolutionChain?.chain?.evolves_to {
                        self.speciesEvolutionArray.append((self.evolutionChain?.chain?.species)!)
                        //var evolvesToData = self.evolutionChain?.chain?.evolves_to;
                        var evolvesToData = evolves
                        var hasEvolution = true
                                      
                        while hasEvolution {
                            if evolvesToData.isEmpty {
                                hasEvolution = false
                                break
                            }
                            if evolvesToData.count == 1 {
                                self.speciesEvolutionArray.append((evolvesToData[0].species)!)
                                evolvesToData = evolvesToData[0].evolves_to!
                            } else {
                                for pokemon in evolvesToData {
                                    self.speciesEvolutionArray.append(pokemon.species!)
                                }
                                evolvesToData = evolvesToData[0].evolves_to!
                            }
                        }
                        self.evolutionCollectionView.reloadData()
                    }
                } else {
                    let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = AlertView.showAlert(title: "Erro", message:"Ocorreu um erro, tente mais tarde novamente")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
    func getAbilities(url: String, index: Int) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    do {
                        if let dataFromJSON = data {
                            self.ability = try self.decoder.decode(AbilitiesDetail.self, from: dataFromJSON)
                        }
                    } catch {
                        let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                        self.present(alert, animated: true, completion: nil)
                    }
                    if let flavor_text_entries = self.ability?.flavor_text_entries {
                        for flavor in flavor_text_entries {                            
                            if (flavor.language?.name?.elementsEqual("en"))! && ((flavor.version_group?.name?.elementsEqual("omega-ruby-alpha-sapphire")) != nil) {
                                if let text = flavor.flavor_text {
                                    self.abilityModalNameLabel.text = self.pokemon?.abilities?[index].ability?.name
                                    self.abilityModalDescriptionTextView.text = text.replacingOccurrences(of: "\n", with: " ")
                                    self.showHideModal(show: true)
                                    break
                                }
                            }
                        }
                    }
                                                            
                    
                } else {
                    let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = AlertView.showAlert(title: "Erro", message:"Ocorreu um erro, tente mais tarde novamente")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getTypesPokemon(url: String, index: Int) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    do {
                        if let dataFromJSON = data {
                            self.type = try self.decoder.decode(TypeDetail.self, from: dataFromJSON)
                        }
                    } catch {
                        let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TypeViewController") as! TypeViewController
                    newViewController.type  = self.type
                    newViewController.pokemonType = (self.types?[index].type?.name)!
                    newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    newViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal                                
                    self.present(newViewController, animated: true, completion: nil)
                                                            
                } else {
                    let alert = AlertView.showAlert(title: "Erro", message:"Não foi retornado nenhum dado")
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = AlertView.showAlert(title: "Erro", message:"Ocorreu um erro, tente mais tarde novamente")
                self.present(alert, animated: true, completion: nil)
            
            }
        }
    }
            
    func showLoadingHub() {
      let loadingView = RSLoadingView()
      loadingView.show(on: view)
    }

    func hideLoadingHub() {
      RSLoadingView.hide(from: view)
    }
    
    private func setPokemonImage() {
        let url = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(String(format: "%03d", id)).png")!
        self.pokemonImageView.kf.setImage(with: url)
        
        var spritesUrlArray: [KingfisherSource] = []
        
        if let front_default = self.pokemon?.sprites?.front_default {
            spritesUrlArray.append(KingfisherSource(urlString: front_default)!)
        }
        
        if let front_female = self.pokemon?.sprites?.front_female {
            spritesUrlArray.append(KingfisherSource(urlString: front_female)!)
        }
        
        if let front_shiny = self.pokemon?.sprites?.front_shiny {
            spritesUrlArray.append(KingfisherSource(urlString: front_shiny)!)
        }
        
        if let front_shiny_female = self.pokemon?.sprites?.front_shiny_female {
            spritesUrlArray.append(KingfisherSource(urlString: front_shiny_female)!)
        }
        
        if let back_default = self.pokemon?.sprites?.back_default {
            spritesUrlArray.append(KingfisherSource(urlString: back_default)!)
        }
        
        if let back_female = self.pokemon?.sprites?.back_female {
            spritesUrlArray.append(KingfisherSource(urlString: back_female)!)
        }
        
        if let back_shiny = self.pokemon?.sprites?.back_shiny {
            spritesUrlArray.append(KingfisherSource(urlString: back_shiny)!)
        }
        
        if let back_shiny_female = self.pokemon?.sprites?.back_shiny_female {            
            spritesUrlArray.append(KingfisherSource(urlString: back_shiny_female)!)
        }
        
        imageSlide.setImageInputs(spritesUrlArray)        
    }
    
    private func setPokemonData() {
        if let name = self.pokemon?.name {
            self.pokemonNameLabel.text = name
        }
        
        if let id = self.pokemon?.id {
            self.pokemonIdLabel.text = "# \(String(format: "%03d", id))"
            
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
        self.abilitiesCollectionView.reloadData()
    }
    
    private func setPokemonTypes() {
        self.types = self.pokemon?.types
        self.typeCollectionView.reloadData()
        self.hideLoadingHub()
    }
    
    func showHideModal(show: Bool) {
        self.shadowView.isHidden = !show
        self.modalView.isHidden = !show
    }
    
    func configureBackGesture() {
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .right
        view.addGestureRecognizer(slideDown)
    }
        
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            self.dismiss(animated: true, completion: nil)
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
            if self.speciesEvolutionArray.count > 0 {
                return self.speciesEvolutionArray.count
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
            self.pokemonMainColor = UIColor(named: (self.types?[indexPath.item].type?.name)!)
            self.backNavBarButton.tintColor = self.pokemonMainColor
            self.segment.backgroundColor = self.pokemonMainColor
            self.abilityLabel.backgroundColor = self.pokemonMainColor
            self.dataDescriptionLabel.backgroundColor = self.pokemonMainColor
            self.spritesLabel.backgroundColor = self.pokemonMainColor
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "evolutionCell", for: indexPath as IndexPath) as! EvolutionCollectionViewCell            
            let id = self.speciesEvolutionArray[indexPath.item].url!.split(separator: "/").last!
            if let url = self.speciesEvolutionArray[indexPath.item].url {
                let id = String(format: "%03d", Int(url.split(separator: "/").last!)!)
                if let imageUrl = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(id).png") {
                    cell.imageView.kf.setImage(with: imageUrl)
                }
            }
            cell.nameLabel.text = self.speciesEvolutionArray[indexPath.item].name
            cell.nameLabel.backgroundColor = self.pokemonMainColor
            
            cell.nameLabel.layer.borderColor = UIColor.darkGray.cgColor
            cell.nameLabel.layer.borderWidth = 1
            cell.nameLabel.layer.cornerRadius = self.view.bounds.width*3/100
            
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
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        } else if collectionView.tag == 2 {
            return CGSize(width: self.view.bounds.width*30/100, height: self.view.bounds.height*4/100)
        }
        return CGSize(width: 0, height: 0)
    }
    
}

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
    var pokemonMainColor: UIColor?
    var showingGif: Bool = false
    
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
    @IBOutlet weak var gifButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setDelegates()
        self.setConstraints()
        self.setCornerRadius()
        
        self.segment.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        self.configureBackGesture()
                
        getPokemon(url: "\(Constants.API_URL)/\(self.id)")
    }
    
    func setDelegates() {
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        
        abilitiesCollectionView.delegate = self
        abilitiesCollectionView.dataSource = self
        
        evolutionCollectionView.delegate = self
        evolutionCollectionView.dataSource = self
    }
    
    func setConstraints() {
        self.pokemonImageBackgroundViewHeight.constant = self.view.bounds.height*24/100
        self.pokemonImageBackgroundViewWidth.constant = self.view.bounds.height*24/100

    }
    
    func setCornerRadius() {
        self.pokemonImageBackgroundView.layer.cornerRadius = self.view.bounds.height*12/100
        
        self.whiteBackgroundView.layer.cornerRadius = self.view.bounds.height*4/100
        self.whiteBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.modalView.layer.cornerRadius = self.view.bounds.height*4/100
        self.modalView.layer.cornerRadius = self.view.bounds.height*4/100
        
        self.abilityLabel.layer.cornerRadius = self.view.bounds.height*1/100
        self.dataDescriptionLabel.layer.cornerRadius = self.view.bounds.height*1/100
        self.spritesLabel.layer.cornerRadius = self.view.bounds.height*1/100
    }
                             
    func getPokemon(url: String) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {                    
                    self.pokemon = data?.toModel()
                    self.setPokemonImage()
                    self.setPokemonData()
                    self.setPokemonStatus()
                    self.setPokemonAbilities()
                    self.setPokemonTypes()
                    if let specieUrl = self.pokemon?.species?.url {
                        self.getSpecie(url: specieUrl)
                    }
                } else {
                    self.showAlert(title: Messages.ERROR_TITLE, message: Messages.NOT_RETURN)
                }
            case .failure(let error):
                self.showAlert(title: Messages.ERROR_TITLE, message: "\(Messages.GENERIC_ERROR) - \n\(error)")
            }
        }
    }
        
    func getSpecie(url: String) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.specie = data?.toModel()
                    if let flavor_text_entries = self.specie?.flavor_text_entries {
                        for flavor in flavor_text_entries {
                            if (flavor.language?.name?.elementsEqual("en"))! && ((flavor.language?.name?.elementsEqual("alpha-sapphire")) != nil) {
                                if let text = flavor.flavor_text {
                                    self.descriptionLabel.text = text.replacingOccurrences(of: "\n", with: " ")
                                }
                            }
                        }
                    }
                                        
                    if let url = self.specie?.evolution_chain?.url {
                        self.getPokemonEvolution(url: url)
                    }
                } else {
                    self.showAlert(title: Messages.ERROR_TITLE, message: Messages.NOT_RETURN)
                }
            case .failure(let error):
                self.showAlert(title: Messages.ERROR_TITLE, message: "\(Messages.GENERIC_ERROR) - \n\(error)")
            }
        }
    }
         
    func getPokemonEvolution(url: String) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.evolutionChain = data?.toModel()
                    if let evolves = self.evolutionChain?.chain?.evolves_to {
                        self.speciesEvolutionArray.append((self.evolutionChain?.chain?.species)!)                        
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
                    self.showAlert(title: Messages.ERROR_TITLE, message: Messages.NOT_RETURN)
                }
            case .failure(let error):
                self.showAlert(title: Messages.ERROR_TITLE, message: "\(Messages.GENERIC_ERROR) - \n\(error)")
            }
        }
    }
        
    func getAbilities(url: String, index: Int) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.ability = data?.toModel()
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
                    self.showAlert(title: Messages.ERROR_TITLE, message: Messages.NOT_RETURN)
                }
            case .failure(let error):
                self.showAlert(title: Messages.ERROR_TITLE, message: "\(Messages.GENERIC_ERROR) - \n\(error)")
            }
        }
    }
    
    func getTypesPokemon(url: String, index: Int) {
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.type = data?.toModel()
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TypeViewController") as! TypeViewController
                    newViewController.type  = self.type
                    newViewController.pokemonType = (self.types?[index].type?.name)!
                    newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    newViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                    self.present(newViewController, animated: true, completion: nil)
                } else {
                    self.showAlert(title: Messages.ERROR_TITLE, message: Messages.NOT_RETURN)
                }
            case .failure(let error):
                self.showAlert(title: Messages.ERROR_TITLE, message: "\(Messages.GENERIC_ERROR) - \n\(error)")
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
        //a api pula do 807 para 10001, verificar porque isso acontece
        //if id < 808 {
            if let url = URL(string: "\(Constants.IMAGE_API_URL)\(String(format: "%03d", id)).png") {
                    self.pokemonImageView.kf.setImage(with: url)
            }
        /*} else {
            
            if let url = URL(string: (self.pokemon?.sprites?.front_default)!) {
                self.pokemonImageView.kf.setImage(with: url)
            }
        }*/
        
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
                self.showAlert(title: Messages.ERROR_TITLE, message: Messages.GENERIC_ERROR)
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
    
    @IBAction func showGif(_ sender: Any) {
        showingGif = !showingGif
        if showingGif {
            if let name = self.pokemon?.name {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let url = URL(string: "http://play.pokemonshowdown.com/sprites/xyani/\(name).gif")!
                    self.pokemonImageView.kf.setImage(with: url)
                    self.gifButton.title = "Imagem"
                }
            }
        } else {
            let url = URL(string: "\(Constants.IMAGE_API_URL)\(String(format: "%03d", id)).png")!
            self.pokemonImageView.kf.setImage(with: url)
            self.gifButton.title = "Gif"
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
            self.gifButton.tintColor = self.pokemonMainColor
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "evolutionCell", for: indexPath as IndexPath) as! EvolutionCollectionViewCell
            if let url = self.speciesEvolutionArray[indexPath.item].url {
                let id = String(format: "%03d", Int(url.split(separator: "/").last!)!)
                if let imageUrl = URL(string: "\(Constants.IMAGE_API_URL)\(id).png") {
                    cell.imageView.kf.setImage(with: imageUrl)
                }
            }
            if let name = self.speciesEvolutionArray[indexPath.item].name {
                cell.nameLabel.text = name
            }
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

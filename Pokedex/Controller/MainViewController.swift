//
//  ViewController.swift
//  Pokedex
//
//  Created by Lucas Daniel on 28/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

class MainViewController: UIViewController {
    
    var pokemons: Pokemons?
    let service = PokedexService()
    var api_url = "https://pokeapi.co/api/v2/pokemon"
    var pokemonArray = [Results?]()
    @IBOutlet weak var collectionView: UICollectionView!
                    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPokemons(url: api_url)
    }
        
    func getPokemons(url: String) {
        service.getAllPokemons(url: url) { result in
            switch result {
            case .success(let data):
                print(data)
                if data != nil {
                    self.pokemons = data
                    self.pokemonArray.append(contentsOf: (data?.results)!)
                    print(self.pokemonArray)
                    self.collectionView.reloadData()
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

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.pokemons?.results != nil {
            return self.pokemonArray.count ?? 0
        }
        return 0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.pokemonArray.count - 4 && self.pokemonArray.count < (self.pokemons?.count)! {
            self.getPokemons(url: (self.pokemons?.next!)!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
                        
        cell.myLabel.text = self.pokemonArray[indexPath.item]?.name
                       
        let url = (self.pokemonArray[indexPath.item]?.url)!
        let id = Int(url.split(separator: "/").last!)!
        let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
        let data = try? Data(contentsOf: imageUrl)
        cell.imageView.image = UIImage(data: data!)
                        
        cell.backgroundColor = UIColor.cyan
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }
    
}

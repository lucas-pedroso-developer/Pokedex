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
        
    @IBOutlet weak var collectionView: UICollectionView!
                    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPokemons(url: api_url)
    }
    
    func getPokemons(url: String) {
        //service.getAllPokemons { result in
        service.getAllPokemons(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.pokemons = data
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
            return self.pokemons?.results!.count ?? 0
        }
        return 0
    }
                
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
                        
        cell.myLabel.text = self.pokemons?.results?[indexPath.item].name
                       
        let url = (self.pokemons?.results?[indexPath.item].url)!
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == itemList.count - 1 && itemList.count < totalCount{
            pageCount += 1
            // Call API here
            print("teste")
        }
    }*/
    
}

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

class MainViewController: UIViewController, UISearchResultsUpdating {
    
    var pokemons: Pokemons?
    var api_url = "https://pokeapi.co/api/v2/pokemon"
    var pokemonArray = [Results?]()
    var pokemonArrayFiltered = [Results?]()
    var searchController: UISearchController!
    var searchActive : Bool = false
    
    let service = PokedexService()
            
    @IBOutlet weak var collectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPokemons(url: api_url)
    }
        
    func getPokemons(url: String) {
        service.getAllPokemons(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.pokemons = data
                    self.pokemonArray.append(contentsOf: (data?.results)!)
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

class SearchBarView: UICollectionReusableView {
    @IBOutlet weak var searchBar: UISearchBar!
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(searchActive) {
            return self.pokemonArrayFiltered.count
        } else if self.pokemons?.results != nil {
            return self.pokemonArray.count
        }
        return 0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !searchActive {
            if indexPath.item == self.pokemonArray.count - 4 && self.pokemonArray.count < (self.pokemons?.count)! {
                self.getPokemons(url: (self.pokemons?.next!)!)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
                        
        if searchActive {
            cell.myLabel.text = self.pokemonArrayFiltered[indexPath.item]?.name
            let url = (self.pokemonArrayFiltered[indexPath.item]?.url)!
            let id = Int(url.split(separator: "/").last!)!
            let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
            let data = try? Data(contentsOf: imageUrl)
            cell.imageView.image = UIImage(data: data!)
        } else {
            if let name = self.pokemonArray[indexPath.item]?.name {
                cell.myLabel.text = name
            }
                                    
            if let url = self.pokemonArray[indexPath.item]?.url {
                let id = Int(url.split(separator: "/").last!)!
                let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
                let data = try? Data(contentsOf: imageUrl)
                cell.imageView.image = UIImage(data: data!)
            }
        }
                        
        cell.backgroundColor = UIColor.cyan
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        if searchActive {
            let url = (self.pokemonArrayFiltered[indexPath.item]?.url)!
            let id = Int(url.split(separator: "/").last!)!
            newViewController.id = id
        } else {
            let url = (self.pokemonArray[indexPath.item]?.url)!
            let id = Int(url.split(separator: "/").last!)!
            newViewController.id = id
        }
        
        newViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        newViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        present(newViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.pokemonArrayFiltered.removeAll()
        for item in self.pokemonArray {
            if let name = item?.name!.lowercased() {
                print(name)
                if ((name.contains(searchBar.text!.lowercased()))) {
                    self.pokemonArrayFiltered.append(item)
                }
            }
        }
            
        if (searchBar.text!.isEmpty) {
            self.pokemonArrayFiltered = self.pokemonArray
        }
        
        searchActive = true
        
        self.collectionView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {}
}

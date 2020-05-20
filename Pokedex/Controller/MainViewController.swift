//
//  ViewController.swift
//  Pokedex
//
//  Created by Lucas Daniel on 28/04/20.
//  Copyright © 2020 Lucas. All rights reserved.
//


import UIKit
import Kingfisher
import RSLoadingView

//reaproveitar
class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

class MainViewController: UIViewController, UISearchResultsUpdating {    
        
    var pokemons: Pokemons?
    var pokemonArray = [Results?]()
    var pokemonArrayFiltered = [Results?]()
    var searchController: UISearchController!
    var searchActive : Bool = false
            
    let service = PokedexService()
            
    @IBOutlet weak var collectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        getPokemons(url: Constants.API_URL)        
    }
            
    func getPokemons(url: String) {
        showLoadingHub()
        service.get(url: url) { result in
            switch result {
            case .success(let data):
                if data != nil {
                    self.pokemons = data?.toModel()
                    self.pokemonArray.append(contentsOf: (self.pokemons?.results)!)
                    self.collectionView.reloadData()
                } else {
                    self.showAlert(title: Messages.ERROR_TITLE, message: Messages.NOT_RETURN)
                    self.hideLoadingHub()
                }
            case .failure(let error):
                self.showAlert(title: Messages.ERROR_TITLE, message: "Ocorreu o seguinte erro - \(error) - Tente mais tarde novamente!")
                self.hideLoadingHub()
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
            self.hideLoadingHub()
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
            let id = String(format: "%03d", Int(url.split(separator: "/").last!)!)            
            let imageUrl = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(id).png")!
            cell.imageView.kf.setImage(with: imageUrl)
        } else {
            if let name = self.pokemonArray[indexPath.item]?.name {
                cell.myLabel.text = name
            }
                                    
            if let url = self.pokemonArray[indexPath.item]?.url {
                let id = String(format: "%03d", Int(url.split(separator: "/").last!)!)                
                let imageUrl = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(id).png")!
                cell.imageView.kf.setImage(with: imageUrl)
            }
        }
                        
        cell.backgroundColor = UIColor.cyan
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        hideLoadingHub()
        
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
        
        newViewController.transitioningDelegate = self
        
        present(newViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }

}

extension MainViewController: UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {}
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.pokemonArrayFiltered.removeAll()
        
        if !searchBar.text!.isEmpty {
            self.searchActive = true
            
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
            
        } else {
            self.searchActive = false
        }
        
        self.collectionView.reloadData()
    }
}

extension MainViewController:  UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension MainViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!

        let isPresentingDrawer = fromView == view
        let drawerView = isPresentingDrawer ? toView : fromView
        if isPresentingDrawer {
            transitionContext.containerView.addSubview(drawerView)
        }
                
        let drawerSize = CGSize(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height)

        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: drawerSize.width * -1, y:0), size: drawerSize)
        let onScreenDrawerFrame = CGRect(origin: .zero, size: drawerSize)
        drawerView.frame = isPresentingDrawer ? offScreenDrawerFrame : onScreenDrawerFrame
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, animations: {
            drawerView.frame = isPresentingDrawer ? onScreenDrawerFrame : offScreenDrawerFrame
        }, completion: { (success) in
            if !isPresentingDrawer {
                drawerView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        })
    }
}


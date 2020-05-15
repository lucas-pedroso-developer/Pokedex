//
//  TypeViewController.swift
//  Pokedex
//
//  Created by Lucas Daniel on 06/05/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit
import Kingfisher
import RSLoadingView

class TypeDetailViewCell: UITableViewCell {
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
}

class TypeViewController: UIViewController {

    var pokemonUrlImage: String?
    var pokemonName: String?
    var pokemonDescription: String?
    var pokemonType: String?
    var type: TypeDetail?
    
    @IBOutlet weak var pokemonTypeLabel: UILabel!
    @IBOutlet weak var typeTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showLoadingHub()
        
        self.typeTableView.delegate = self
        self.typeTableView.dataSource = self
        
        self.pokemonTypeLabel.text = pokemonType!
        self.pokemonTypeLabel.backgroundColor = UIColor(named: pokemonType!)
        self.backButton.tintColor = UIColor(named: pokemonType!)
        
        self.configureBackGesture()
        
        self.typeTableView.reloadData()
    }
    
    func showLoadingHub() {
      let loadingView = RSLoadingView()
      loadingView.show(on: view)
    }

    func hideLoadingHub() {
      RSLoadingView.hide(from: view)
    }
    
    func configureBackGesture() {
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .right
        view.addGestureRecognizer(slideDown)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}

extension TypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type != nil {
            return (self.type?.pokemon!.count)!
        }
        self.hideLoadingHub()
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "typeDetailCell", for: indexPath as IndexPath) as!  TypeDetailViewCell
        cell.nameLabel.text = self.type?.pokemon?[indexPath.row].pokemon?.name
        let url = (self.type?.pokemon?[indexPath.row].pokemon?.url)!
        let id = Int(url.split(separator: "/").last!)!
        let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
        cell.typeImageView.kf.setImage(with: imageUrl)
        self.hideLoadingHub()
        return cell
    }
    
    
}

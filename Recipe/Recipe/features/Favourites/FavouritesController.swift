//
//  FavouritesController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;
import PromiseKit;
import Disk;

class FavouritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
    var favourites = [Recipe]()
    //var favouritesIds = [String]()
    var favouritesIds: Set<String> = []
    let pathToFavouritesIds = "Recipes/favouriteData.json"
    var defaultRecipe = Recipe(id: "1")
    @IBOutlet weak var table: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let encoder = JSONEncoder()
        try? Disk.save(favouritesIds, to: .caches, as: pathToFavouritesIds, encoder: encoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let decoder = JSONDecoder()
        var recipesInitiator: [Promise<Recipe>] = [];
        
        if Disk.exists(pathToFavouritesIds, in: .caches) {
            let data = try? Disk.retrieve(pathToFavouritesIds, from: .caches, as: Set<String>.self, decoder: decoder)
            
            if data != nil {
                favouritesIds = data!
                let sortedIds = data?.sorted()
                for id in sortedIds! {
                    let recipe = Recipe(id: id)
                    recipesInitiator.append(recipe.getShortRecipe())
                }
                _ = when(fulfilled: recipesInitiator).done {
                    (result: [Recipe]) in
                    self.favourites = result
                    
                    self.table.reloadData()
                }
            } else {
                self.favourites = []
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCellReuse", for: indexPath) as! FavouriteTableCellView;
        
        cell.initInternal(data: favourites[indexPath.row]);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeOverviewController = RecipeOverviewController.instantiate(fromAppStoryboard: .RecipeOverviewController);
        _ = favourites[indexPath.row].getFullRecipe()
            .done{(recipe:Recipe) in
                recipeOverviewController.setModel(recipe: recipe);
                self.present(recipeOverviewController, animated: true, completion: nil);
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favouritesIds.remove(favourites[indexPath.row].id)
            favourites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

class FavouriteTableCellView: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    func initInternal(data: Recipe){
        self.recipeLabel.text = data.name
        self.recipeImage.image = #imageLiteral(resourceName: "test5.jpg")
    }
}

class FavouriteRecipe {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage){
        self.name = name
        self.image = image
    }
}

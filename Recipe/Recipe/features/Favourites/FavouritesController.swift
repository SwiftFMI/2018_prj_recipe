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

class FavouritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
    var favourites = [Recipe]()
    
    var defaultRecipe = Recipe(id: "1")
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var recipePromise = defaultRecipe.getShortRecipe()
        /*for _ in 1...5 {
            favourites.append(defaultRecipe)
        }*/
        table.rowHeight = 80
        
        var recepiesInitiator: [Promise<Recipe>] = [];
        for _ in 0...4 {
            let recipe = Recipe(id:String(1));
            recepiesInitiator.append(recipe.getShortRecipe())
        }
        
        when(fulfilled: recepiesInitiator).done { (result:[Recipe]) in
            self.favourites = result;
            self.table.reloadData()
        }
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
        favourites[indexPath.row].getFullRecipe()
            .done{(recipe:Recipe) in
                recipeOverviewController.setModel(recipe: recipe);
                self.present(recipeOverviewController, animated: true, completion: nil);
        }
    }
    
}

class FavouriteTableCellView: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    func initInternal(data: Recipe){
        self.recipeLabel.text = data.name
        self.recipeImage.image = #imageLiteral(resourceName: "test5.jpg")
        print("Ok")
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

//
//  RecipeOverview.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 16.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;

class RecipeOverviewController: UIViewController {
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeAuthor: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    
    @IBOutlet weak var recipeTimeToPrepare: UILabel!
    @IBOutlet weak var recipeTimeToCook: UILabel!
    var currentRecipe: ShortRecipe = ShortRecipe(name: "Lorem", description: "Impsum", photo: #imageLiteral(resourceName: "DefaulRecipeImage"))!
    
    override func viewDidLoad() {
        self.recipeName.text = "Some Recipe Name"
        self.recipeDescription.text = currentRecipe.description
        self.recipeTimeToPrepare.text = currentRecipe.timeToPrepare
        self.recipeTimeToCook.text = currentRecipe.timeToCook
        self.recipeIngredients.text = currentRecipe.ingredients
        self.recipeAuthor.text = "Mihail Kirilov"
        super.viewDidLoad();
	}
}

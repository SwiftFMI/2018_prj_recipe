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
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeAuthor: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    
    @IBOutlet weak var recipeTimeToPrepare: UILabel!
    @IBOutlet weak var recipeTimeToCook: UILabel!
    var currentRecipe: Recipe = Recipe()
	
	
	override func viewDidAppear(_ animated: Bool) {
		scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
	}
	override func viewDidLoad() {
        self.recipeName.text = currentRecipe.name
        self.recipeDescription.text = currentRecipe.shortDescription
        self.recipeTimeToPrepare.text = currentRecipe.timeToPrepare
        self.recipeTimeToCook.text = currentRecipe.timeToCook
        self.recipeIngredients.text = "aaaaaaa"
        self.recipeAuthor.text = currentRecipe.author
        super.viewDidLoad();
	}
	override func viewWillLayoutSubviews(){
		super.viewWillLayoutSubviews();
	}
}

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
	
	
	
	private var recipeModel: Recipe? = nil;
	
	func setModel(recipe data:Recipe){
		self.recipeModel = data;
//		self.recipeModel = Recipe();
//		self.recipeModel?.author = data.author;
//		self.recipeModel?.longDescription = data.desc;
//		self.recipeModel?.ingredients = data.ingredients as! [Ingredient];
	}
	
	override func viewDidAppear(_ animated: Bool) {
		scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
	}
	
	override func viewDidLoad() {
		if self.recipeModel != nil {
			self.recipeName.text = recipeModel!.name
			self.recipeDescription.text = recipeModel!.shortDescription
			self.recipeTimeToPrepare.text = recipeModel!.timeToPrepare
			self.recipeTimeToCook.text = recipeModel!.timeToCook
			self.recipeIngredients.text = "aaaaaaa"
			self.recipeAuthor.text = recipeModel!.author
		}
        super.viewDidLoad();
	}
	override func viewWillLayoutSubviews(){
		super.viewWillLayoutSubviews();
	}
}

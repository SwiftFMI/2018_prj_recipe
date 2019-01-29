//
//  TabBarController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//
import RAMAnimatedTabBarController;

class TabBarController: RAMAnimatedTabBarController {
	override func viewDidLoad() {
		super.viewDidLoad();
		
		let exploreScene = ExploreController.instantiate(fromAppStoryboard: .Explore);
		let favouritesScene = FavouritesController.instantiate(fromAppStoryboard: .Favourites);
		let shoppingListScene = ShoppingListController.instantiate(fromAppStoryboard: .ShoppingList);
		let createRecipeScene = CreateRecipeController.instantiate(fromAppStoryboard: .CreateRecipe);
		let abaoutScene = AboutPageController.instantiate(fromAppStoryboard: .AboutPage);
		
		self.viewControllers = [exploreScene,favouritesScene,shoppingListScene,createRecipeScene,abaoutScene];
	}
	
}

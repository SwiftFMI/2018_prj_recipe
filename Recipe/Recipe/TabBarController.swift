//
//  TabBarController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//
import RAMAnimatedTabBarController;
import Firebase;

class TabBarController: RAMAnimatedTabBarController {
		
	override func viewDidLoad() {
		super.viewDidLoad();
		
		let exploreScene = ExploreController.instantiate(fromAppStoryboard: .Explore);
		let favouritesScene = FavouritesController.instantiate(fromAppStoryboard: .Favourites);
		let shoppingListScene = ShoppingListController.instantiate(fromAppStoryboard: .ShoppingList);
		let createRecipeScene = CreateRecipeController.instantiate(fromAppStoryboard: .CreateRecipe);
		let abaoutScene = AboutPageController.instantiate(fromAppStoryboard: .AboutPage);		
		self.viewControllers = [exploreScene,favouritesScene,shoppingListScene,createRecipeScene,abaoutScene];
		
		
		
//		ref.child("allRecipeIDs").observe(.value) { (snapshot) in
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? DataSnapshot {
//                self.addRecipeIdToCache(snapshot: rest)
//            }
//			ref.child("ingredients").observe(.value) { (snapshot) in
//				let enumerator = snapshot.children
//				while let rest = enumerator.nextObject() as? DataSnapshot {
//					let name = rest.childSnapshot(forPath: "name").value as! String
//					var isLiquid = ""
//					var isQuantity = ""
//					if rest.childSnapshot(forPath: "isLuquid").exists(){
//						isLiquid = "true"
//					}else if rest.childSnapshot(forPath: "isQuantity").exists(){
//						isQuantity = "true"
//					}
//					cachedIngredientList[rest.key] = Ingredient(key: rest.key, name: name, isLiquid: isLiquid == "true" ? true : false, isQuantity: isQuantity == "true" ? true : false);
//				}
//
////				cachedRecipeIDS[snapshot.key ?? ""] = ""
//
//				let exploreScene = ExploreController.instantiate(fromAppStoryboard: .Explore);
//				let favouritesScene = FavouritesController.instantiate(fromAppStoryboard: .Favourites);
//				let shoppingListScene = ShoppingListController.instantiate(fromAppStoryboard: .ShoppingList);
//				let createRecipeScene = CreateRecipeController.instantiate(fromAppStoryboard: .CreateRecipe);
//				let abaoutScene = AboutPageController.instantiate(fromAppStoryboard: .AboutPage);
//
//				self.viewControllers = [exploreScene,favouritesScene,shoppingListScene,createRecipeScene,abaoutScene];
//			}
//		}
//
//        ref.child("allRecipeIDs").observe(.childAdded){ (snapshot) in
//            self.addRecipeIdToCache(snapshot: snapshot)
//        }
	}
}

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
		
		
		ref.child("allRecipeIDs").observe(.value) { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.addRecipeIdToCache(snapshot: rest)
            }
			ref.child("ingredients").observe(.childAdded) { (snapshot) in
				let name = snapshot.childSnapshot(forPath: "name").value as! String
				var isLiquid = ""
				var isQuantity = ""
				if snapshot.childSnapshot(forPath: "isLuquid").exists(){
					isLiquid = "true"
				}else if snapshot.childSnapshot(forPath: "isQuantity").exists(){
					isQuantity = "true"
				}
				cachedIngredientList[snapshot.key] = ["name": name, "isLiquid": isLiquid, "isQuantity": isQuantity];
			}
			
			cachedRecipeIDS[snapshot.key ?? ""] = ""
			
			let exploreScene = ExploreController.instantiate(fromAppStoryboard: .Explore);
			let favouritesScene = FavouritesController.instantiate(fromAppStoryboard: .Favourites);
			let shoppingListScene = ShoppingListController.instantiate(fromAppStoryboard: .ShoppingList);
			let createRecipeScene = CreateRecipeController.instantiate(fromAppStoryboard: .CreateRecipe);
			let abaoutScene = AboutPageController.instantiate(fromAppStoryboard: .AboutPage);
			
			self.viewControllers = [exploreScene,favouritesScene,shoppingListScene,createRecipeScene,abaoutScene];
		}
		
        ref.child("allRecipeIDs").observe(.childAdded){ (snapshot) in
            self.addRecipeIdToCache(snapshot: snapshot)
        }
	}
    
    private func addRecipeIdToCache(snapshot: DataSnapshot){
        cachedRecipeIDS[snapshot.key] = ""
    }
	
}

//
//  ViewController.swift
//  Recipe
//
//  Created by Mihail Kirilov on 14.11.18.
//  Copyright © 2018 Mihail Kirilov. All rights reserved.
//

import UIKit;
import RAMAnimatedTabBarController;
import Firebase;

class InitialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
		
		ref.child("allRecipeIDs").observe(.value) { (snapshot) in
			let enumerator = snapshot.children
			while let rest = enumerator.nextObject() as? DataSnapshot {
				self.addRecipeIdToCache(snapshot: rest)
			}
			ref.child("ingredients").observe(.value) { (snapshot) in
				let enumerator = snapshot.children
				while let rest = enumerator.nextObject() as? DataSnapshot {
					let name = rest.childSnapshot(forPath: "name").value as! String
					var isLiquid = ""
					var isQuantity = ""
					if rest.childSnapshot(forPath: "isLuquid").exists(){
						isLiquid = "true"
					}else if rest.childSnapshot(forPath: "isQuantity").exists(){
						isQuantity = "true"
					}
					cachedIngredientList[rest.key] = Ingredient(key: rest.key, name: name, isLiquid: isLiquid == "true" ? true : false, isQuantity: isQuantity == "true" ? true : false);
				}
				
				let newViewController = TabBarController();
				self.present(newViewController, animated:true, completion:nil);
			}
		}
		
		ref.child("allRecipeIDs").observe(.childAdded){ (snapshot) in
			self.addRecipeIdToCache(snapshot: snapshot)
		}
		
        // Do any additional setup after loading the view, typically from a nib.
    }
	
	private func addRecipeIdToCache(snapshot: DataSnapshot){
		cachedRecipeIDS[snapshot.key] = ""
	}

}


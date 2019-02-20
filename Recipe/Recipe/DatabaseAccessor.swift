//
//  DatabaseAccessor.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 17.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase
import FirebaseStorage

class RecipeDatabase{
	private static let ref: DatabaseReference! = Database.database().reference(withPath: "/")
	
	public static func getRecipe(id:String)->Promise<RecipeData>{
		return Promise { dfd in
			ref.child("recipes/\(id)").observe(.value) { (snapshot) in
//				if snapshot == nil {
//					return;
////					dfd.reject(Error("asd"));
//				}
				let ingredientsDic = snapshot.childSnapshot(forPath: "ingredients").value as! NSDictionary
				var ingredients:[Any] = [];
				for (ingredient, amount) in ingredientsDic {
					ingredients.append(Ingredient(key: ingredient as! String, quantity: (amount as! AnyObject).floatValue ?? 0.0))
				}
				let data = RecipeData(
					auth: snapshot.childSnapshot(forPath: "author").value as! String,
					desc: snapshot.childSnapshot(forPath: "longDescription").value as! String,
					ingredients: ingredients
				);
				dfd.resolve(data,nil);
			}
		}
	}
	
	public static func getShortRecipe(id:String)->Promise<RecipeShortData>{
		return Promise { dfd in
			ref.child("short-recipes/\(id)").observe(.value) { (snapshot) in
                let storage = Storage.storage();
                let storageRef = storage.reference()
                let islandRef = storageRef.child("recipesPhotos/\(snapshot.key)")
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    var image: UIImage? = nil
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // Data for "images/island.jpg" is returned
                        image = UIImage(data: data!)
                    }
                
				let shortRecipeData:RecipeShortData = RecipeShortData(
					timeToPrepare: "\(snapshot.childSnapshot(forPath: "minutesToPrepare").value ?? "")",
					timeToCook: "\(snapshot.childSnapshot(forPath: "minutesToCook").value ?? "")",
					shortDescription: "\(snapshot.childSnapshot(forPath: "shortDescription").value ?? "")",
                    shortIngredientList: "\(snapshot.childSnapshot(forPath: "shortIngredientList").value ?? "")",
					name:"\(snapshot.childSnapshot(forPath: "name").value ?? "")",
					id: id,
                    image: image)
                    dfd.resolve(shortRecipeData, nil);
                }
				
			}
		}
	}
}

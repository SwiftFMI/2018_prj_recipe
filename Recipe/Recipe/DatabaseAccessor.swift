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
				let shortRecipeData:RecipeShortData = RecipeShortData(
					timeToPrepare: "\(snapshot.childSnapshot(forPath: "minutesToPrepare").value ?? "")",
					timeToCook: "\(snapshot.childSnapshot(forPath: "minutesToCook").value ?? "")",
					shortDescription: snapshot.childSnapshot(forPath: "shortDescription").value as! String,
					shortIngredientList: snapshot.childSnapshot(forPath: "shortIngredientList").value as! String,
					name:"\(snapshot.childSnapshot(forPath: "name").value ?? "")",
					id: id)
				dfd.resolve(shortRecipeData, nil);
			}
		}
	}
}

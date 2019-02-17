//
//  RecipeTestClass.swift
//  Recipe
//
//  Created by Georgi Stoilov on 16.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import PromiseKit

var ref: DatabaseReference! = Database.database().reference(withPath: "/")

class Ingredient {
    var key: String = ""
    var name: String = ""
    var quantity: Float = 0.0
    var measuringUnit: (String, String) = ("kg", "gr")
    var image: UIImage = UIImage(imageLiteralResourceName: "Apple")
    
    init(key: String, quantity: Float){
        self.key = key
        self.quantity = quantity
        
//        ref.child("ingredients/\(key)").add{ (snapshot) in
//            if !snapshot.exists() {
//                self.name = self.key
//            }else{
//                self.name = snapshot.childSnapshot(forPath: "name").value as! String
//                let isLiquid = snapshot.childSnapshot(forPath: "isLuquid")
//                let isQuantity = snapshot.childSnapshot(forPath: "isQuantity")
//                if isLiquid.exists(){
//                    self.measuringUnit = ("l", "ml")
//                }else if isQuantity.exists(){
//                    self.measuringUnit = ("", "")
//                }
//                self.image = UIImage(imageLiteralResourceName: self.key)
//            }
//        }
    }
}

protocol ShortRecipeProtocol {
	var timeToPrepare: String? { get set }
	var timeToCook: String? { get set }
	var shortDescription: String? { get set }
	var shortIngredientList: String? { get set }
	var id:String { get set }
	var name:String? { get set }
}

struct RecipeData {
	let author:String;
	let desc:String;
	let ingredients:[Any];
	init(auth:String,desc:String,ingredients:[Any]){
		self.author = auth;
		self.desc = desc;
		self.ingredients = ingredients;
	}
}

struct RecipeShortData:ShortRecipeProtocol {
	var timeToPrepare: String?
	
	var timeToCook: String?
	
	var shortDescription: String?
	
	var shortIngredientList: String?
	
	var name: String?
	
	var id: String
	
	init(timeToPrepare:String,timeToCook:String,shortDescription:String,shortIngredientList:String,name:String,id:String){
		self.id = id;
		self.timeToCook = timeToCook;
		self.shortDescription = shortDescription;
		self.shortIngredientList = shortIngredientList;
		self.name = name;
	}
}

class Recipe:ShortRecipeProtocol {
    
	var id: String;
	var name: String?;
    var shortDescription: String?
    var longDescription: String?
//    var photo: UIImage?
    var timeToPrepare: String?
    var timeToCook: String?
    var author: String?
	var isFull:Bool?;
    var shortIngredientList: String?
    var ingredients: [Ingredient] = []
	
	init(id:String){
		self.id = id;
		self.isFull = false;
	}
    
    func getShortRecipe() -> Promise<Recipe> {
		return Promise { dfd in
			RecipeDatabase.getShortRecipe(id: self.id)
				.done { (data:RecipeShortData) in
					self.name = data.name;
					self.shortIngredientList = data.shortIngredientList;
					self.shortDescription = data.shortDescription;
					self.timeToPrepare = data.timeToPrepare;
					self.timeToCook = data.timeToCook;
					dfd.resolve(self,nil);
			}
		}
    }
    
    func getFullRecipe() -> Promise<Recipe> {
		return Promise { dfd in
			RecipeDatabase.getRecipe(id: self.id)
			.done { (data:RecipeData) in
				self.author = data.author;
				self.longDescription = data.desc;
				self.ingredients = data.ingredients as! [Ingredient];
				self.isFull = true;
				dfd.resolve(self,nil);
			}
		}
    }
}



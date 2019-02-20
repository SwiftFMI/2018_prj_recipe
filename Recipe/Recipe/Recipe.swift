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
import SearchTextField;

var ref: DatabaseReference! = Database.database().reference(withPath: "/")

final class Ingredient:SearchTextFieldItem,Decodable {
	var key: String = "";
	var quantity: Float = 0.0;
	var measuringUnit: (String, String) = ("kg", "gr");
	var name: String {
		get { return self.title }
	}
	
//	USE TITLE FROM SearchTextFieldItem
//	var name: String = "";
//	USE IMAGE FROM SearchTextFieldItem
//	var image: UIImage? = nil;
	
	enum CodingKeys: String, CodingKey
	{
		case key
		case name
		case quantity
		case measuringUnitMin
		case measuringUnitMax
	}
	
    init(key: String, quantity: Float){
		self.key = key
		self.quantity = quantity
		self.measuringUnit = (cachedIngredientList[key]?.measuringUnit)!;
		
		let title = cachedIngredientList[key]?.name ?? key
		super.init(title: title)
		self.image = UIImage.getImageOrDefault(named: key)
    }
	init(key:String, name:String, isLiquid: Bool, isQuantity: Bool) {
		self.key = key;
		self.quantity = 0;
		if isLiquid == true {
			self.measuringUnit = ("l", "ml")
		}else if isQuantity == true {
			self.measuringUnit = ("","")
		}
		super.init(title: name)
		self.image = UIImage.getImageOrDefault(named: key);
	}
	
	init(key:String,name:String, quantity: Float,measuringUnit:(String, String)) {
		self.key = key;
		super.init(title:name);
		self.quantity = quantity;
		self.measuringUnit = measuringUnit;
		self.image = UIImage.getImageOrDefault(named: key);
	}
	
	init(from decoder: Decoder) throws
	{
		let values = try decoder.container(keyedBy: CodingKeys.self);
		self.key = try values.decode(String.self, forKey: .key);
		self.quantity = try values.decode(Float.self, forKey: .quantity)
		let measuringUnitMin = try values.decode(String.self, forKey: .measuringUnitMin);
		let measuringUnitMax = try values.decode(String.self, forKey: .measuringUnitMax);
		self.measuringUnit = (measuringUnitMin,measuringUnitMax);
		let title = try values.decode(String.self, forKey: .name);
		super.init(title:title);
		self.image = UIImage.getImageOrDefault(named: key);
	}
}

extension Ingredient: Encodable
{
	func encode(to encoder: Encoder) throws
	{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(key, forKey: .key);
		try container.encode(title, forKey: .name);
		try container.encode(quantity, forKey: .quantity);
		try container.encode(measuringUnit.0, forKey: .measuringUnitMin);
		try container.encode(measuringUnit.1, forKey: .measuringUnitMin);
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
        self.timeToPrepare = timeToPrepare
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



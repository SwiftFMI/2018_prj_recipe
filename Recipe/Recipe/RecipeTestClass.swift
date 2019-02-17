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
        
        ref.child("ingredients/\(key)").observe(.value){ (snapshot) in
            if !snapshot.exists() {
                self.name = self.key   
            }else{
                self.name = snapshot.childSnapshot(forPath: "name").value as! String
                let isLiquid = snapshot.childSnapshot(forPath: "isLuquid")
                let isQuantity = snapshot.childSnapshot(forPath: "isQuantity")
                if isLiquid.exists(){
                    self.measuringUnit = ("l", "ml")
                }else if isQuantity.exists(){
                    self.measuringUnit = ("", "")
                }
                self.image = UIImage(imageLiteralResourceName: self.key)
            }
        }
    }
}



class Recipe {
    
    var id: String = "-1"
    var name: String = ""
    var shortDescription: String = ""
    var longDescription: String = ""
//    var photo: UIImage?
    var timeToPrepare: String = ""
    var timeToCook: String = ""
    var author: String = ""
    
    var shortIngredientList: String? = ""
    var ingredients: [Ingredient] = []
    
    var reload: () -> Void = { () in return};
    
    func getShortRecipe(recipeID: String) -> Void {
        self.id = recipeID
        ref.child("short-recipes/\(self.id)").observe(.value) { (snapshot) in
            self.name = snapshot.childSnapshot(forPath: "name").value as! String
            self.shortDescription = snapshot.childSnapshot(forPath: "shortDescription").value as! String
            self.timeToPrepare = "\(snapshot.childSnapshot(forPath: "minutesToPrepare").value ?? "")"
            self.timeToCook = "\(snapshot.childSnapshot(forPath: "minutesToCook").value ?? "")"
            self.shortIngredientList = snapshot.childSnapshot(forPath: "shortIngredientList").value as! String
            self.reload()
        }
        
//        ref.child("short-recipes").observe(.childAdded) { (snapshot) in
//            let name =
//            let shortIngredientList = snapshot.childSnapshot(forPath: "shortIngredientList").value as! String
//            let shortDescription = snapshot.childSnapshot(forPath: "shortDescription").value as! String + " [" + shortIngredientList + "]"
//
//            let minutesToCook = snapshot.childSnapshot(forPath: "minutesToCook").value ?? ""
//            let minutesToPrepare = snapshot.childSnapshot(forPath: "minutesToPrepare").value ?? ""
//            let recipeID = snapshot.key
//
//            let sr = ShortRecipe(recipeID: recipeID, name: name, description: shortDescription, photo: #imageLiteral(resourceName: "test.jpg"), timeToPrepare: "\(minutesToPrepare)" , timeToCook: "\(minutesToCook)")!
//
//            if index < 4 {
//                self.shortRecipes[index] = sr
//            }
//            index += 1
//            
//        }
    }
    
    func getRecipe() -> Recipe {
        if self.id == "-1" {
            return self
        }
        ref.child("recipes/\(self.id)").observe(.value) { (snapshot) in
            self.author = snapshot.childSnapshot(forPath: "author").value as! String
            self.longDescription = snapshot.childSnapshot(forPath: "longDescription").value as! String
            
            let ingredients = snapshot.childSnapshot(forPath: "ingredients").value as! NSDictionary
            for (ingredient, amount) in ingredients {
//                self.ingredients += []
                Ingredient(key: ingredient as! String, quantity: (amount as! AnyObject).floatValue ?? 0.0)
            }
        }

        return self
    }

    func callFirebaseAndUpdateCurrentRecipeInView(view: RecipeOverviewController) -> Void {
        view.currentRecipe = self.getRecipe()
    }
}

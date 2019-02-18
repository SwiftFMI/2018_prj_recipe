//
//  CreateRecipeController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;
import Firebase;


class CreateRecipeController: UIViewController {
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    @IBOutlet weak var nameOfTheRecipeTextField: UITextField!
    @IBOutlet weak var shortDescriptionRecipeTextView: UITextView!
    @IBOutlet weak var longDescriptionRecipeTextView: UITextView!
    @IBOutlet weak var timeToPrepareTextField: UITextField!
    @IBOutlet weak var timeToCookTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    @IBAction func createRecipe(_ sender: Any) {
        
        let ref: DatabaseReference! = Database.database().reference(withPath: "/")
        let recipeID = ref.child("recipes").childByAutoId().key ?? String(format: "%06X%06X", Int(arc4random() % 65535), Int(arc4random() % 65535))
        let recipeShortData = [
            "name": nameOfTheRecipeTextField.text ?? "",
            "minutesToCook": timeToCookTextField.text ?? "",
            "minutesToPrepare": timeToPrepareTextField.text ?? "",
            "shortDescription": shortDescriptionRecipeTextView.text ?? "",
            "shortIngredientList": "SomeSome"
            ]
        
        let ingredientList = [
            "Egg": 2
        ]
        
        let recipeLongData = [
            "author": authorTextField.text ?? "",
            "longDescription": longDescriptionRecipeTextView.text ?? "",
            "ingredients": ingredientList
            ] as [String : Any]
        
        let recipeData = [
            "recipes/\(recipeID)" : recipeLongData,
            "short-recipes/\(recipeID)" : recipeShortData,
            "allIngredientIDs" : ["\(recipeID)" : "" ]
            ] as [String : Any]
        
        ref.updateChildValues(recipeData)
    }
    //		return;
//	}
	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		return;
//	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
	}
}

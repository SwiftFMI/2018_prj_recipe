//
//  RecipeTestClass.swift
//  Recipe
//
//  Created by Georgi Stoilov on 16.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation
import UIKit

class ShortRecipe {
    var mockData: [(name: String, shortDescription: String,image: UIImage, time:  String, cooking: String)] = []
    var id: String
    var name: String
    var description: String
    var photo: UIImage?
    var timeToPrepare: String
    var timeToCook: String
    var author: String?
    var longDescription: String?
    var ingredients: String?
    
    init?(name: String, description: String, photo: UIImage?, timeToPrepare: String = "∞", timeToCook: String = "∞", recipeID: String = "-1") {
        
        // Initialization should fail in this case:
        if name.isEmpty || description.isEmpty || timeToCook.isEmpty || timeToPrepare.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.id = recipeID
        self.name = name
        self.description = description
        self.photo = photo
        self.timeToPrepare = timeToPrepare
        self.timeToCook = timeToCook
    }
    
}

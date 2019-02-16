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
    var name: String
    var description: String
    var photo: UIImage?
    var time: String
    var cooking: String
    
    init?(name: String, description: String, photo: UIImage?, time: String, cooking:String) {
        
        // Initialization should fail in this case:
        if name.isEmpty || description.isEmpty || time.isEmpty || cooking.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.description = description
        self.photo = photo
        self.time = time
        self.cooking = cooking
    }
    
}

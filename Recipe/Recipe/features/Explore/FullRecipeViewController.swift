//
//  FullRecipeViewController.swift
//  Recipe
//
//  Created by Georgi Stoilov on 13.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation
import UIKit

class FullRecipeViewController: UIViewController {
    
    
    
    @IBOutlet weak var recipeName: UILabel!
    
    var name: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeName.text = name
    }    
}

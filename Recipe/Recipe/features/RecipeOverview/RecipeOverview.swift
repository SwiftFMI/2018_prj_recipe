//
//  RecipeOverview.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 16.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;
import Disk;

let pathToFavouritesIds = "Recipes/favouriteData.json"

class RecipeOverviewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
	
	@IBOutlet weak var timeToPrepare: UILabel!
	@IBOutlet weak var timeToCook: UILabel!
	@IBOutlet weak var favouritesIcon: UIImageView!
	
	@IBOutlet weak var instructionsView: UITextView!
	@IBOutlet weak var ingredientsTableHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeAuthor: UILabel!
//    @IBOutlet weak var recipeDescription: UILabel!
	@IBOutlet weak var ingredientsTable: UITableView!
	
	private var isFavourited = false;
	private var isFavouritedChanged = false;
	private var recipeModel: Recipe? = nil;
	
	func setModel(recipe data:Recipe){
		self.recipeModel = data;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.recipeModel?.ingredients.count)!;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath) as! IngredientCell;
		
		cell.initInternal(ingredient: (self.recipeModel?.ingredients[indexPath.row])!);
		
		return cell;
	}
	
	@IBAction func backHandler(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil);
	}
	override func viewDidAppear(_ animated: Bool) {
		instructionsView.sizeToFit();
		instructionsView.isScrollEnabled = false;
		scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+instructionsView.frame.height);
		
	}
	
	override func viewDidLoad() {
		if self.recipeModel != nil {
			self.recipeName.text = recipeModel!.name
			self.timeToPrepare.text = recipeModel!.timeToPrepare
			self.timeToCook.text = recipeModel!.timeToCook
			self.recipeAuthor.text = recipeModel!.author
			let tableHeight =
				(self.recipeModel?.ingredients.count)! * 45
			self.ingredientsTableHeightConstraint.constant = CGFloat(tableHeight);
			self.view.layoutIfNeeded();
			self.ingredientsTable.tableFooterView = UIView(frame: .zero)
			
//			let favouritesIds:[String] = [];
			if Disk.exists(pathToFavouritesIds, in: .caches){
				let data = try? Disk.retrieve(pathToFavouritesIds, from: .caches, as: Set<String>.self, decoder: JSONDecoder())
				if data != nil && data!.count > 0 {
					if data?.first(where: {
						$0 == self.recipeModel?.id;
					}) != nil {
						self.favouritesIcon.image = UIImage(named:"Apple");
						self.isFavourited = true;
					}else{
						self.isFavourited = false;
						self.favouritesIcon.image = UIImage(named: "Avocado");
					}
				}
			}else {
				self.favouritesIcon.image = UIImage(named: "Avocado");
			}
			
		}
        super.viewDidLoad();
	}
	override func viewWillLayoutSubviews(){
		super.viewWillLayoutSubviews();
	}
	
	@IBAction func addAndRemoveFromFavourites(_ sender: Any) {
		isFavourited = !isFavourited;
		isFavouritedChanged = true;
		favouritesIcon.image = isFavourited ? UIImage(named: "Apple") : UIImage(named: "Avocado");
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		if(isFavouritedChanged) {
			if(isFavourited){
				let recipeIds = try? Disk.retrieve(pathToFavouritesIds, from: .caches, as: Set<String>.self, decoder: JSONDecoder())
				if recipeIds != nil && recipeIds!.count > 0 {
					if recipeIds!.filter({ $0 ==  self.recipeModel!.id }).count != 0{
						return;
					}
					try? Disk.append(self.recipeModel!.id, to: pathToFavouritesIds, in: .caches);
				}
			} else {
				let recipeIds = try? Disk.retrieve(pathToFavouritesIds, from: .caches, as: Set<String>.self, decoder: JSONDecoder())
				if recipeIds != nil && recipeIds!.count > 0 {
					let newIds =  recipeIds!.filter { $0 !=  self.recipeModel!.id }
					try? Disk.remove(pathToFavouritesIds, from: .caches);
					try? Disk.save(newIds, to: .caches, as: pathToFavouritesIds, encoder: JSONEncoder());
				}
			}
		}
	}
}

class IngredientCell: UITableViewCell{
	var ingredientTitle = "";
	@IBOutlet weak var ingredientImg: UIImageView!
	@IBOutlet weak var label: UILabel!
	
	func initInternal(ingredient:Ingredient){
		self.label!.text = ingredient.name;
		self.ingredientImg.image = ingredient.image;
	}
}

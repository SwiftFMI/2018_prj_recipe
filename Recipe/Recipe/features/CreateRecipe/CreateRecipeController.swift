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
import SearchTextField;
import PromiseKit;
import Disk
import Photos

class CreateRecipeController: UIViewController,UITableViewDelegate,UITableViewDataSource,RemoveIngredientViewCellDelegate,AddIngredientViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet weak var ingredientsHeight: NSLayoutConstraint!
	@IBOutlet weak var scrollContentView: NSLayoutConstraint!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var nameOfTheRecipeTextField: UITextField!
    @IBOutlet weak var shortDescriptionRecipeTextView: UITextView!
    @IBOutlet weak var longDescriptionRecipeTextView: UITextView!
    @IBOutlet weak var timeToPrepareTextField: UITextField!
    @IBOutlet weak var timeToCookTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
	@IBOutlet weak var ingredientsTable: UITableView!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
	var ingredients:[Ingredient] = [Ingredient(key: "Banana", quantity: 1)];
    
    let imagePicker = UIImagePickerController()
    
    var imageNsUrl = NSURL()
    var imageUrl: String = ""
    @IBAction func pickImageButtonAction(_ sender: UIButton) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        var access = false
        switch status {
        case .denied:
            print("You don't have permission")
        case .authorized:
            print("You have permission to use photos")
            access = true
        case .notDetermined:
            print("Status not determined")
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if(newStatus == .denied){
                    print("You don't have permission again")
                    access = false
                }else if(newStatus == .authorized){
                    print("You have access.")
                    access = true
                }
            }
        default:
            print("Undefined.")
            access = false
        }
        
        if access {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] {
            recipeImage.contentMode = .scaleAspectFit
            recipeImage.image = pickedImage as? UIImage
            
            if let pickedUrl = info[UIImagePickerController.InfoKey.imageURL]{
                imageNsUrl =  pickedUrl as! NSURL
                imageUrl = imageNsUrl.absoluteString ?? ""
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
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
        
//        ref.updateChildValues(recipeData)
        
        let id = "1"
        let recipe = Recipe(id: id)

        _ = when(fulfilled: [recipe.getShortRecipe()]).done { (result: [Recipe]) in
            _ = when(fulfilled: [recipe.getFullRecipe()]).done { (result: [Recipe]) in
              
                let recipeOverviewController = RecipeOverviewController.instantiate(fromAppStoryboard: .RecipeOverviewController);
                let favouritesController = FavouritesController.instantiate(fromAppStoryboard: .Favourites);
                recipeOverviewController.setModel(recipe: recipe);
                recipeOverviewController.setBackController(favouritesController: favouritesController);
                
                var favouritesIds: Set<String> = []
                let pathToFavouritesIds = "Recipes/favouriteData.json";
                let decoder = JSONDecoder()
                favouritesIds = []
                if Disk.exists(pathToFavouritesIds, in: .caches){
                    let data = try? Disk.retrieve(pathToFavouritesIds, from: .caches, as: Set<String>.self, decoder: decoder)
                    if data != nil {
                        favouritesIds = data!
                    }
                }
                favouritesIds.insert(id);
                try? Disk.save(favouritesIds, to: .caches, as: pathToFavouritesIds, encoder: JSONEncoder())
                
                self.present(recipeOverviewController, animated: true, completion: nil);
            }
        }
    }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// + 1 is cuz we want 1 extra cell for adding data
		return ingredients.count + 1;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row < ingredients.count {
			let cell = tableCellFactory(identifier: "addedRow", indexPath: indexPath) as! AddedCell;
			cell.initInternal(ingredient: ingredients[indexPath.row]);
			cell.delegate = self;
			return cell as UITableViewCell
		}else{
			let cell = tableCellFactory(identifier: "addingRow", indexPath: indexPath) as! AddingCell;
			cell.initInternal();
			cell.delegate = self;
			return cell as UITableViewCell;
		}
	}
	
	func addIngredientDelegateHandler(ingredient:Ingredient) {
		self.ingredients.append(ingredient);
		self.ingredientsTable.beginUpdates();
		self.ingredientsTable.insertRows(at: [IndexPath(row: self.ingredients.count-1, section: 0)], with: .automatic);
		self.ingredientsTable.endUpdates();
		self.ingredientsHeight.constant += 45;
	}
	
	func removeIngredientDelegateHandler(){
		//add removing from Misho here
		self.ingredientsHeight.constant -= 45;
	}
	
	func tableCellFactory(identifier:String,indexPath:IndexPath)->UITableViewCell{
		let cell = self.ingredientsTable.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! IngredientsTableCell;
		return cell as UITableViewCell;
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
        
        imagePicker.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		registerNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unregisterNotifications()
	}
	
	private func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func unregisterNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@IBAction func hideKeyboard(_ sender: Any) {
		self.nameOfTheRecipeTextField.endEditing(true);
		self.shortDescriptionRecipeTextView.endEditing(true);
		self.longDescriptionRecipeTextView.endEditing(true);
		self.timeToPrepareTextField.endEditing(true);
		self.timeToCookTextField.endEditing(true);
		self.authorTextField.endEditing(true);
		let lastCell = self.ingredientsTable.visibleCells[self.ingredientsTable.visibleCells.count-1] as! AddingCell;
		lastCell.ingredientTypeField.endEditing(true);
		lastCell.quantityField.endEditing(true);
	}
	
	@objc func keyboardWillShow(notification: NSNotification){
		guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height;
		
	}
	
	@objc func keyboardWillHide(notification: NSNotification){
		scrollView.contentInset.bottom = 0;
	}
}

protocol RemoveIngredientViewCellDelegate: AnyObject {
	func removeIngredientDelegateHandler()
}

protocol AddIngredientViewCellDelegate: AnyObject {
	func addIngredientDelegateHandler(ingredient:Ingredient)
}


class IngredientsTableCell: UITableViewCell{
	func initInternal(){
		fatalError("Override in child classes")
	}
}

class AddedCell: IngredientsTableCell {
	@IBOutlet weak var ingredientImage: UIImageView!
	@IBOutlet weak var ingradientName: UILabel!
	@IBOutlet weak var quantityIdentifier: UILabel!
	weak var delegate : RemoveIngredientViewCellDelegate?;
	@IBAction func removeIngredient(_ sender: UIButton) {
		if let _ = delegate {
			self.delegate?.removeIngredientDelegateHandler();
		}
	}
	func initInternal(ingredient:Ingredient) {
		ingradientName.text = ingredient.name;
		ingredientImage.image = ingredient.image;
		self.quantityIdentifier.text = "\(String(ingredient.quantity) )" + "\(ingredient.measuringUnit.0)"
	}
}

class AddingCell: IngredientsTableCell{
	@IBOutlet weak var ingredientTypeField: SearchTextField!
	@IBOutlet weak var quantityField: UITextField!
	
	weak var delegate : AddIngredientViewCellDelegate?;
	var selectedIngredient:Ingredient?;
	
	@IBAction func addIngredient(_ sender: UIButton) {
		if let _ = delegate {
			if selectedIngredient == nil {
				let writenIngredient = Array(cachedIngredientList).first(where: {
					$0.value.name == ingredientTypeField.text;
				});
				if writenIngredient != nil {
					selectedIngredient = Ingredient(key: writenIngredient!.key, quantity: 0);
				}else{
					return;
				}
			}
			selectedIngredient?.quantity = Float(quantityField.text!) ?? 1;
			let image = cachedIngredientList[(selectedIngredient?.key)!]?.image;
			selectedIngredient?.image = image;
			self.delegate?.addIngredientDelegateHandler(ingredient:selectedIngredient!);
			self.quantityField.text = "";
			self.ingredientTypeField.text="";
			self.ingredientTypeField.becomeFirstResponder();
		}
	}
	
	override func initInternal() {
		var ingredientItems:[Ingredient] = []
		for (key,_) in Array(cachedIngredientList){
			let item = Ingredient(key: key, quantity: 0);
			item.image = nil;
			ingredientItems.append(item);
		}
		self.ingredientTypeField.filterItems(ingredientItems);
		
		self.ingredientTypeField.itemSelectionHandler = { filteredResults, itemPosition in
			let item = filteredResults[itemPosition] as! Ingredient;
			self.selectedIngredient = item;
			self.ingredientTypeField.text = item.title;
		}
	}
}

//class IngredientSearchItem:SearchTextFieldItem{
//	var ingredientKey:String="";
//	init(key:String,title: String, subtitle: String?, image: UIImage?) {
//		self.ingredientKey = key;
//		super.init(title: title);
////		super.init(title: title, subtitle: subtitle, image: image);
//	}
//}

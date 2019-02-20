//
//  PopUpDialogController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 11.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;
import EasyPopUp;
import SearchTextField;

class PopupDialogController: UIViewController,UIGestureRecognizerDelegate {
	@IBOutlet weak var itemQuantity: UITextField!
	@IBOutlet var contentView: UIView!;
	@IBOutlet weak var searchInput: SearchTextField!
	
	var selectedItem:Ingredient?=nil;
	var products:Array<Ingredient> = [] // сложи всички продукти от firebase тук
	var add:(_ item:Ingredient)->Void = { (item) in return };
	var cancel: ()->Void = { () in return };
	
	@IBAction func cancelHandler(_ sender: Any) {
		self._cancel();
	}
	
	@IBAction func viewTapCancel(_ sender: Any) {
		self._cancel();
	}
	@IBAction func addHandler(_ sender: UIButton) {
		self._addHandler();
	}
	
	@IBAction func viewTapAction(_ sender: Any) {
		self._addHandler();
	}
	
	func _addHandler(){
		let itemQuantity:Float = self.itemQuantity.text != nil && self.itemQuantity.text != "" ? Float(self.itemQuantity.text!)! : 0.0;
		
		self.selectedItem?.quantity = itemQuantity
		if self.selectedItem != nil {
			self.add(self.selectedItem!);
		}
		self.dismiss(animated: true, completion: nil);
	}
	
	func _cancel(){
		self.cancel();
		self.dismiss(animated: true, completion: nil);
	}
	
	@IBAction func tapAction(_ sender: Any) {
		searchInput.endEditing(true);
		itemQuantity.endEditing(true);
	}
	
	override func viewDidAppear(_ animated: Bool) {
		searchInput.becomeFirstResponder();
		searchInput.filterItems(Array(cachedIngredientList).map { (_,value) in
			return value;
		});
		searchInput.itemSelectionHandler = { item, itemPosition in
			self.selectedItem =  item[0] as? Ingredient;
			self.searchInput.text = self.selectedItem?.title;
		}
	}
	
	@IBOutlet weak var addToListHandler: UIView!
	override func viewDidLoad() {
		super.viewDidLoad();
	}
}

extension PopupDialogController : EasyPopUpViewControllerDatasource {
	var popupView: UIView {
		return contentView;
	}
}

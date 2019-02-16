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
	
	var selectedItem:ShoppingListData?=nil;
	var products:Array<SearchTextFieldItem> = []; // сложи всички продукти от firebase тук
	var add:(_ item:ShoppingListData)->Void = { (item) in return };
	var cancel: ()->Void = { () in return };
	
	@IBAction func cancelHandler(_ sender: Any) {
		self.cancel();
		self.dismiss(animated: true, completion: nil);
	}
	
	@IBAction func addHandler(_ sender: UIButton) {
		let itemQuantity:Int = self.itemQuantity.text != nil && self.itemQuantity.text != "" ? Int(self.itemQuantity.text!)! : 0;
		self.selectedItem?.itemCount = itemQuantity
		if self.selectedItem != nil {
			self.add(self.selectedItem!);
		}
		self.dismiss(animated: true, completion: nil);
		
	}
	@IBAction func tapAction(_ sender: Any) {
		searchInput.endEditing(true);
		itemQuantity.endEditing(true);
	}
	override func viewDidAppear(_ animated: Bool) {
		searchInput.becomeFirstResponder();
		searchInput.filterItems(products);
		searchInput.itemSelectionHandler = { item, itemPosition in
			self.selectedItem =  item[0] as? ShoppingListData;
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

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

class PopupDialogController: UIViewController {
	@IBOutlet var contentView: UIView!;
	@IBOutlet weak var searchInput: SearchTextField!
	
	override func viewWillAppear(_ animated: Bool) {
	}
	
	override func viewDidAppear(_ animated: Bool) {
		let item1 = SearchTextFieldItem(title: "Blue", subtitle: nil, image: UIImage(named: "Apple"))
		let item2 = SearchTextFieldItem(title: "Red", subtitle: nil, image: UIImage(named: "Apple"))
		let item3 = SearchTextFieldItem(title: "Yellow", subtitle: nil, image: UIImage(named: "Apple"))
		searchInput.placeholder = "Search for ingredient";
		
		searchInput.filterItems([item1, item2, item3])
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		contentView.frame.size.height = self.view.frame.size.height * 0.8;
		contentView.frame.size.width = self.view.frame.size.width * 0.8;
		
		searchInput.frame.size.height = 40;
		searchInput.frame.size.width = contentView.frame.size.width * 0.8;
		
	}
}

extension PopupDialogController : EasyPopUpViewControllerDatasource {
	var popupView: UIView {
		return contentView;
	}
}

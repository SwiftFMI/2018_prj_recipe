//
//  ShoppingListController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;

class ShoppingListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	let mockData = [ShoppingListData(name: "Спанак", count: 2, units: "кутии", imagePath: "img.png"),
					ShoppingListData(name: "Чери домати", count: 100, units: "гр.", imagePath: "img.png"),
					ShoppingListData(name: "Картофи", count: 1, units: "кг.", imagePath: "img.png"),
					ShoppingListData(name: "Свинско месо", count: 300, units: "гр.", imagePath: "img.png")];
	@IBOutlet weak var table: UITableView!
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mockData.count;
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableRow", for: indexPath) as! ShoppingListTableRow;
		
		cell.initInternal(rowData: mockData[indexPath.row]);
		
		return cell;
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
	}
}

class ShoppingListTableRow: UITableViewCell {
	@IBOutlet weak var itemName: UILabel!
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var itemCount: UILabel!
	@IBOutlet weak var units: UILabel!
	
	func initInternal(rowData data:ShoppingListData) -> Void {
		self.itemName?.text = data.itemName;
		self.itemCount?.text = "\(data.itemCount)";
		self.imageView?.image = data.image;
		self.units?.text = data.units;
	}
}

struct ShoppingListData {
	let image:UIImage?;
	let itemName:String;
	let itemCount:Int;
	let units:String;
	init(name itemName:String,count itemCount: Int,units:String,imagePath imageName:String) {
		self.itemName = itemName;
		self.itemCount = itemCount;
		self.units = units;
		self.image = UIImage(named: imageName);
		
		//read from Documents folder
//		let documentDirectory = FileManager.SearchPathDirectory.documentDirectory;
//		let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask;
//		let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true);
//		if let dirPath = paths.first
//		{
//			let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName);
//			self.image = UIImage(named: imagePath);
//		}else{
//			self.image = nil;
//		}
	}
}

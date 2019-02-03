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
	var mockData = [ShoppingListData(name: "Спанак", count: 2, units: "кутии", imagePath: "Apple"),
					ShoppingListData(name: "Чери домати", count: 100, units: "гр.", imagePath: "Apple"),
					ShoppingListData(name: "Картофи", count: 1, units: "кг.", imagePath: "Apple"),
					ShoppingListData(name: "Свинско месо", count: 300, units: "гр.", imagePath: "Apple")];
	@IBOutlet weak var table: UITableView!
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mockData.count;
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableRow", for: indexPath) as! ShoppingListTableRow;
		
		cell.initInternal(rowData: mockData[indexPath.row]);
		
		return cell;
	}
	@objc func swipeToRemoveHandler(_ sender: UISwipeGestureRecognizer) {
		if sender.state == UIGestureRecognizer.State.ended {
			let location = sender.location(in: self.table)
			if let indexPath = table.indexPathForRow(at: location) {
				mockData.remove(at: indexPath.row);
				table.deleteRows(at: [indexPath], with: .left);
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad();
		let recognizer = UISwipeGestureRecognizer(target: self, action:#selector(swipeToRemoveHandler(_:)));
		recognizer.direction = .left;
		self.table.addGestureRecognizer(recognizer);
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
	
	@IBAction func addQuantity(_ sender: UIButton) {
		self.itemCount.text = "\(Int(self.itemCount.text!)! + findDelta())";
	}
	
	@IBAction func removeQuantity(_ sender: UIButton) {
		self.itemCount.text = "\(Int(self.itemCount.text!)! - findDelta())";
	}
	
	func findDelta()->Int{
		switch(self.units?.text){
		case "кг.": return 1;
		case "гр.":
			if let len = self.itemCount.text?.count {
				return NSDecimalNumber(decimal: pow(10,len-1)).intValue;
			}else{
				return 1;
			}
		default: return 1;
		}
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
	}
}

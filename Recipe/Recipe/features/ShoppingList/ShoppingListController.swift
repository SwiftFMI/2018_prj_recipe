//
//  ShoppingListController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;
import Disk;
import EasyPopUp;

class ShoppingListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
	var tableData:Array<ShoppingListData> = [];
	@IBOutlet weak var table: UITableView!
	
	override func viewWillAppear(_ animated: Bool) {
		
		let decoder = JSONDecoder()
		//		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let encoder = JSONEncoder();
		let mockData = [ShoppingListData(name: "Спанак", count: 2, units: "кутии", imagePath: "Apple"),
						ShoppingListData(name: "Чери домати", count: 100, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Картофи", count: 1, units: "кг.", imagePath: "Apple"),
						ShoppingListData(name: "Свинско месо", count: 300, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Спанак", count: 2, units: "кутии", imagePath: "Apple"),
						ShoppingListData(name: "Чери домати", count: 100, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Картофи", count: 1, units: "кг.", imagePath: "Apple"),
						ShoppingListData(name: "Свинско месо", count: 300, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Спанак", count: 2, units: "кутии", imagePath: "Apple"),
						ShoppingListData(name: "Чери домати", count: 100, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Картофи", count: 1, units: "кг.", imagePath: "Apple"),
						ShoppingListData(name: "Свинско месо", count: 300, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Спанак", count: 2, units: "кутии", imagePath: "Apple"),
						ShoppingListData(name: "Чери домати", count: 100, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Картофи", count: 1, units: "кг.", imagePath: "Apple"),
						ShoppingListData(name: "Свинско месо", count: 300, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Спанак", count: 2, units: "кутии", imagePath: "Apple"),
						ShoppingListData(name: "Чери домати", count: 100, units: "гр.", imagePath: "Apple"),
						ShoppingListData(name: "Картофи", count: 1, units: "кг.", imagePath: "Apple"),
						ShoppingListData(name: "Свинско месо", count: 300, units: "гр.", imagePath: "Apple")];
		try? Disk.save(mockData, to: Disk.Directory.caches, as: "Recipes/shoppinglistData.json",encoder:encoder);
		
		
		let data = try? Disk.retrieve("Recipes/shoppinglistData.json", from: Disk.Directory.caches, as: [ShoppingListData].self, decoder: decoder);
		if data != nil {
			self.tableData = data!;
		}else{
			self.tableData = [];
		}
	}
	
	@IBAction func completeTouchHandler(_ sender: UIButton) {
		for (index, _) in self.tableData.enumerated().reversed() {
			self.tableData.remove(at: index);
			let indexPath = IndexPath(item:index,section:0);
			self.table.deleteRows(at: [indexPath], with: .left);
			}
//		do {
//			try Disk.remove("Recipes/shoppinglistData.json", from: .caches)
//		} catch {
//			print("Cannot delete shopping list!")
//		}
	}
	
	@IBAction func addButtonHandler(_ sender: UIButton) {
		var config = EasyPopupConfig();
		config.animationType = .scale;
		config.cornerRadius = CGFloat(20);
		config.blurBackground = true;
		config.blurRadius = CGFloat(10);
		let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "popupDialog") as! PopupDialogController
		let easePopUp = EasyViewControllerPopup(sourceViewController: self, destinationViewController: popupVC,config:config);
		
		easePopUp.showVCAsPopup();
	}
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableData.count;
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableRow", for: indexPath) as! ShoppingListTableRow;
		
		cell.initInternal(rowData: tableData[indexPath.row]);
		
		return cell;
	}
	@objc func swipeToRemoveHandler(_ sender: UISwipeGestureRecognizer) {
		if sender.state == UIGestureRecognizer.State.ended {
			let location = sender.location(in: self.table)
			if let indexPath = table.indexPathForRow(at: location) {
				tableData.remove(at: indexPath.row);
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
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
//		contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
	}
}

struct ShoppingListData {
	let image:UIImage?;
	private let imageName:String;
	let itemName:String;
	let itemCount:Int;
	let units:String;
	
	enum CodingKeys: String, CodingKey
	{
		case itemName
		case itemCount
		case units
		case imageName
	}
	
	init(name itemName:String,count itemCount: Int,units:String,imagePath imageName:String) {
		self.itemName = itemName;
		self.itemCount = itemCount;
		self.units = units;
		self.imageName = imageName;
		self.image = UIImage(named: imageName);
	}
}

extension ShoppingListData: Encodable
{
	func encode(to encoder: Encoder) throws
	{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(itemName, forKey: .itemName);
		try container.encode(itemCount, forKey: .itemCount);
		try container.encode(units, forKey: .units);
		try container.encode(imageName, forKey: .imageName);
	}
}

extension ShoppingListData: Decodable
{
	init(from decoder: Decoder) throws
	{
		let values = try decoder.container(keyedBy: CodingKeys.self);
		self.itemName = try values.decode(String.self, forKey: .itemName);
		self.itemCount = try values.decode(Int.self, forKey: .itemCount);
		self.units = try values.decode(String.self, forKey: .units);
		self.imageName = try values.decode(String.self, forKey: .imageName);
		self.image = UIImage(named: self.imageName);
	}
}

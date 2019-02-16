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
import SearchTextField;

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
		var easePopUp:EasyViewControllerPopup? = nil;
		config.animationType = .scale;
		config.cornerRadius = CGFloat(20);
		config.blurBackground = true;
		config.blurRadius = CGFloat(10);
		let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "popupDialog") as! PopupDialogController;
		popupVC.products = self.tableData;
		
		popupVC.add = { (item:ShoppingListData) in
			var location = -1;
			for (index, value) in self.tableData.enumerated(){
				if value.title == item.title{
					location = index;
					break;
				}
			}
			if location != -1 {
				let tableCell = self.table.cellForRow(at: IndexPath(row: location, section: 0)) as! ShoppingListTableRow;
				tableCell.itemCount?.text = String(Int((tableCell.itemCount?.text)!)! + item.itemCount);
			} else {
				self.tableData.append(item);
				self.table.beginUpdates();
				self.table.insertRows(at: [IndexPath(row: self.tableData.count-1, section: 0)], with: .automatic);
				self.table.endUpdates();
			}
		}
		popupVC.cancel = { () in
			//
		}
		easePopUp = EasyViewControllerPopup(sourceViewController: self, destinationViewController: popupVC,config:config);
		
		easePopUp!.showVCAsPopup();
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
		self.itemName?.text = data.title;
		self.itemCount?.text = "\(data.itemCount)";
		self.imageView?.image = data.image;
		self.units?.text = data.units;
	}
	
	@IBAction func addQuantity(_ sender: UIButton) {
		self.itemCount.text = "\(Int(self.itemCount.text!)! + findDelta())";
	}
	
	@IBAction func removeQuantity(_ sender: UIButton) {
		self.itemCount.text = "\(Int(self.itemCount.text!)! - findDelta())";
		if self.itemCount.text == "0" {
			sender.isEnabled = false;
		}
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
	}
}

final class ShoppingListData:SearchTextFieldItem,Decodable {
//	let image:UIImage?;
	private var imageName:String;
//	let itemName:String;
	var itemCount:Int;
	var units:String ;
	
	enum CodingKeys: String, CodingKey
	{
		case title
		case itemCount
		case units
		case imageName
	}
	
	init(name itemName:String,count itemCount: Int,units:String,imagePath imageName:String) {
		let img = UIImage(named: imageName);
		self.itemCount = itemCount;
		self.units = units;
		self.imageName = imageName;
		super.init(title: itemName,subtitle: "",image: img);
	}
	
	init(from decoder: Decoder) throws
	{
		let values = try decoder.container(keyedBy: CodingKeys.self);
		let title = try values.decode(String.self, forKey: .title);
		self.imageName = try values.decode(String.self, forKey: .imageName);
		let image = UIImage(named: self.imageName);
		self.itemCount = try values.decode(Int.self, forKey: .itemCount)
		self.units = try values.decode(String.self, forKey: .units);
		super.init(title:title,subtitle:"",image:image);
	}
}

extension ShoppingListData: Encodable
{
	func encode(to encoder: Encoder) throws
	{
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: .title);
		try container.encode(itemCount, forKey: .itemCount);
		try container.encode(units, forKey: .units);
		try container.encode(imageName, forKey: .imageName);
	}
}

//extension ShoppingListData: Decodable
//{
//	init(from decoder: Decoder) throws
//	{
//		let values = try decoder.container(keyedBy: CodingKeys.self);
//		self.title = try values.decode(String.self, forKey: .title);
//		self.itemCount = try values.decode(Int.self, forKey: .itemCount);
//		self.units = try values.decode(String.self, forKey: .units);
//		self.imageName = try values.decode(String.self, forKey: .imageName);
//		self.image = UIImage(named: self.imageName);
//	}
//}

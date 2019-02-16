//
//  utils.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;

enum AppStoryboard : String {
	
	case Main,Explore,Favourites,ShoppingList,CreateRecipe,AboutPage;
	
	var instance : UIStoryboard {
		
		return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
	}
	
	func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
		
		let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
		
		guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
			
			fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
		}
		
		return scene
	}
	
	func initialViewController() -> UIViewController? {
		
		return instance.instantiateInitialViewController()
	}
}

extension UIViewController {
	
	// Not using static as it wont be possible to override to provide custom storyboardID then
	class var storyboardID : String {
		
		return "\(self)"
	}
	
	static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
		
		return appStoryboard.viewController(viewControllerClass: self)
	}
}

// USAGE :
//let storyboard = AppStoryboard.Main.instance

//extension UIViewController
//{
//	func hideKeyboard()
//	{
//		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//			target: self,
//			action: #selector(UIViewController.dismissKeyboard))
//		
//		tap.cancelsTouchesInView = false
//		view.addGestureRecognizer(tap)
//	}
//	
//	@objc func dismissKeyboard()
//	{
//		view.endEditing(true)
//	}
//}

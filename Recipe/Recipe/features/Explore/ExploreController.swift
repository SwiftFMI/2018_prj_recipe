//
//  ExploreController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//
import Firebase
import Foundation;
import UIKit;
import Koloda;

class ExploreController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    
	@IBAction func openRecipeHandler(_ sender: UITapGestureRecognizer) {
		print("asd");
	}

    // Array of ShortRecipe, which can be found in RecipeTestClass.swift
    var shortRecipes: [ShortRecipe] = []
    
    override func loadView() {
        super.loadView()
        FirebaseApp.configure()
        
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "/")
        
        var index = 0;
        ref.child("short-recipes").observe(.childAdded) { (snapshot) in
            let name = snapshot.childSnapshot(forPath: "name").value as! String
            let shortIngredientList = snapshot.childSnapshot(forPath: "shortIngredientList").value as! String
            let shortDescription = snapshot.childSnapshot(forPath: "shortDescription").value as! String + " [" + shortIngredientList + "]"
            
            let minutesToCook = snapshot.childSnapshot(forPath: "minutesToCook").value ?? ""
            let minutesToPrepare = snapshot.childSnapshot(forPath: "minutesToPrepare").value ?? ""
            let recipeID = snapshot.key
            
            let sr = ShortRecipe(name: name, description: shortDescription, photo: #imageLiteral(resourceName: "test.jpg"), timeToPrepare: "\(minutesToPrepare)" , timeToCook: "\(minutesToCook)", recipeID: recipeID)!
            
            if index < 4 {
                self.shortRecipes[index] = sr
            }
            index += 1
            self.kolodaView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // new part:
        let defauiltShortRecipe = ShortRecipe(name: "DefaultRecipe", description: "DefaultRecipeDescription", photo: #imageLiteral(resourceName: "DefaulRecipeImage"))!
        for _ in 0...4 {
            shortRecipes.append(defauiltShortRecipe)
        }
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        kolodaView.layer.cornerRadius = 5
        kolodaView.layer.masksToBounds = true
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "fullRecipe" {
//			print("Hello");
//            //let navigationController = segue.destination as! UINavigationController
//            //let targetController = navigationController.topViewController as? FullRecipeViewController
//            if let nextViewController = segue.destination as? RecipeOverview {
//				let recipeScene = RecipeOverview.instantiate(fromAppStoryboard: .RecipeOverview);
////                nextViewController.name = self.mockData[self.kolodaView.currentCardIndex].name
//            }
//            //targetController?.image?.image = self.mockData[self.kolodaView.currentCardIndex].image
//        }
//    }
}

extension ExploreController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {

        kolodaView.resetCurrentCardIndex()
        kolodaView.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        // When clicked on the recipe, needs to go to screen for it.
//        let currentRecipe = shortRecipes[index]
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "/")
        let currentRecipe = shortRecipes[index]
        ref.child("recipes/\(currentRecipe.id)").observe(.value) { (snapshot) in
            currentRecipe.author = snapshot.childSnapshot(forPath: "author").value as? String
            currentRecipe.longDescription = snapshot.childSnapshot(forPath: "longDescription").value as? String
//            currentRecipe.ingredients =  as? String
            let ingredients = snapshot.childSnapshot(forPath: "ingredients").value as! NSDictionary
            var array = [String]()
            for (ingredient, amount) in ingredients {
                array += ["\(ingredient) \(amount)"]
            }
            
            currentRecipe.ingredients = array.joined(separator:" ")
            
//            a.
            let recipeOverviewController = RecipeOverviewController.instantiate(fromAppStoryboard: .RecipeOverviewController);
//            recipeOverviewController.currentRecipe = p shortRecipes[index]
            self.present(recipeOverviewController, animated: true, completion: nil);
        }
        
        
//        performSegue(withIdentifier: "fullRecipe", sender: nil)
        //prepare(for: , sender: <#T##Any?#>
    }
}

extension ExploreController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 5
        
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        //return UIImageView(image: images[index])
        let swiper: SwipeCardView!
        swiper = SwipeCardView(frame: CGRect(x: 0, y: 0, width: kolodaView.bounds.width, height: kolodaView.bounds.height))

        let data = shortRecipes[index]
        swiper.caption = data.name
        swiper.image = data.photo
        swiper.shorDescription = data.description
        swiper.timeToPrepare = data.timeToPrepare
        swiper.timeToCook = data.timeToCook
        return swiper
        //return UIImageView(image: #imageLiteral(resourceName: "info.png"))
    }
     
    //func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //    return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    //}
}

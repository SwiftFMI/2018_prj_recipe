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
import PromiseKit;

class ExploreController: UIViewController {
    
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var kolodaView: KolodaView!

    // Array of ShortRecipe, which can be found in RecipeTestClass.swift
    var shortRecipes: [Recipe] = []
    var usedRecipes: [String] = []
    var numberOfKolodaCartds: Int = 2
    let arrayWithAllRecipeIDS: [String] = Array(cachedRecipeIDS.keys)
//    override func loadView() {
//        super.loadView()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
		
//		RecipeDatabase.getRecipe(id: <#T##String#>)
		
//		let defauiltShortRecipe = Recipe(id:"1")
//        defauiltShortRecipe.reload = { () in
//            self.kolodaView.reloadData()
//        }
//        defauiltShortRecipe.getShortRecipe(recipeID: "1")
        self.loadRecipesIntoKoloda()
        
		loadingView.isHidden = false;
        kolodaView.layer.cornerRadius = 5
        kolodaView.layer.masksToBounds = true
    }
    
    func loadRecipesIntoKoloda() -> Void {
        var recepiesInitiator:[Promise<Recipe>] = [];
        for _ in 0..<self.numberOfKolodaCartds {
            let arrayWithAllUnusedRecipes = arrayWithAllRecipeIDS.filter { !usedRecipes.contains($0) }
            
            if arrayWithAllUnusedRecipes.count > 0 {
                let randomID = Int.random(in: 0 ..< arrayWithAllUnusedRecipes.count)
                let currentRecipeId = arrayWithAllUnusedRecipes[randomID]
                usedRecipes.append(currentRecipeId)
                let recipe = Recipe(id:currentRecipeId);
                recepiesInitiator.append(recipe.getShortRecipe())
            }else{
                
            }
            
            if arrayWithAllUnusedRecipes.count < self.numberOfKolodaCartds{
                self.numberOfKolodaCartds = arrayWithAllUnusedRecipes.count
            }
        }
        
        when(fulfilled: recepiesInitiator).done { (result:[Recipe]) in
            self.shortRecipes = result;

            if (self.usedRecipes.count == self.numberOfKolodaCartds) {
                self.kolodaView.dataSource = self
                self.kolodaView.delegate = self
            }
            if self.loadingView.isHidden != true{
                self.loadingView.isHidden = true
            }
        }
    }
}

extension ExploreController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let arrayWithAllUnusedRecipes = arrayWithAllRecipeIDS.filter { !usedRecipes.contains($0) }
        
        if arrayWithAllUnusedRecipes.count != 0{
            kolodaView.resetCurrentCardIndex()
            self.loadRecipesIntoKoloda()
        }else{
            
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let recipeOverviewController = RecipeOverviewController.instantiate(fromAppStoryboard: .RecipeOverviewController);
		shortRecipes[index].getFullRecipe()
			.done{(recipe:Recipe) in
				recipeOverviewController.setModel(recipe: recipe);
				self.present(recipeOverviewController, animated: true, completion: nil);
		}
    }
}

extension ExploreController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
		return self.numberOfKolodaCartds ;
        
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
        swiper.shorDescription = data.shortDescription
        swiper.timeToPrepare = data.timeToPrepare
        swiper.timeToCook = data.timeToCook
        return swiper
        //return UIImageView(image: #imageLiteral(resourceName: "info.png"))
    }
     
    //func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //    return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    //}
}

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
import Disk;

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
    
    var favouritesIds: Set<String> = []
    let pathToFavouritesIds = "Recipes/favouriteData.json"
    override func viewWillDisappear(_ animated: Bool) {
        let encoder = JSONEncoder()
        try? Disk.save(favouritesIds, to: .caches, as: pathToFavouritesIds, encoder: encoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let decoder = JSONDecoder()
        favouritesIds = []
        if Disk.exists(pathToFavouritesIds, in: .caches){
            let data = try? Disk.retrieve(pathToFavouritesIds, from: .caches, as: Set<String>.self, decoder: decoder)
            if data != nil {
                favouritesIds = data!
            }
        }
        //try? Disk.remove(pathToFavouritesIds, from: .caches)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let encoder = JSONEncoder()
        
        favouritesIds.removeAll()
        try? Disk.save(favouritesIds, to: Disk.Directory.caches, as: "Recipes/favouriteData.json", encoder: encoder)*/
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
        
        _ = when(fulfilled: recepiesInitiator).done { (result:[Recipe]) in
            self.shortRecipes = result;
            if (self.usedRecipes.count == self.numberOfKolodaCartds) {
                self.kolodaView.dataSource = self
                self.kolodaView.delegate = self
            }
            if self.loadingView.isHidden != true{
                self.loadingView.isHidden = true
            }
            
            self.kolodaView.resetCurrentCardIndex()
        }
    }
}

extension ExploreController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let arrayWithAllUnusedRecipes = arrayWithAllRecipeIDS.filter { !usedRecipes.contains($0) }
        
        if arrayWithAllUnusedRecipes.count != 0{
            self.loadRecipesIntoKoloda()
        }else{
            
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let recipeOverviewController = RecipeOverviewController.instantiate(fromAppStoryboard: .RecipeOverviewController);
		_ = shortRecipes[index].getFullRecipe()
            .done{(recipe:Recipe) in
				recipeOverviewController.setModel(recipe: recipe);
				self.present(recipeOverviewController, animated: true, completion: nil);
		}
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            favouritesIds.insert(shortRecipes[index].id)
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
        swiper.image = data.image 
        return swiper
        //return UIImageView(image: #imageLiteral(resourceName: "info.png"))
    }
     
    //func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //    return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    //}
}

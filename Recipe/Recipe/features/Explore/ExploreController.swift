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
    var shortRecipes: [Recipe] = []
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // new part:
        let defauiltShortRecipe = Recipe()
        defauiltShortRecipe.reload = { () in
            self.kolodaView.reloadData()
        }
        defauiltShortRecipe.getShortRecipe(recipeID: "1")
        
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
        
        
        let recipeOverviewController = RecipeOverviewController.instantiate(fromAppStoryboard: .RecipeOverviewController);
        
        ///
        shortRecipes[index].callFirebaseAndUpdateCurrentRecipeInView(view: recipeOverviewController)
        self.present(recipeOverviewController, animated: true, completion: nil);
        
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

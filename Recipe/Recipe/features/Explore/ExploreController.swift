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
    
    var mockData: [(name: String, shortDescription: String,image: UIImage, time:  String, cooking: String)] = []
    var fireBaseRecipes: [(recipeID: String, name: String, shortDescription: String,image: UIImage, time:  String, cooking: String)] = []
    
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
            
            let minutesToCook = snapshot.childSnapshot(forPath: "minutesToCook").value
            let minutesToPrepare = snapshot.childSnapshot(forPath: "minutesToPrepare").value
            let recipeID = snapshot.key
            
            self.fireBaseRecipes += [(recipeID: recipeID, name: name, shortDescription: shortDescription, image: #imageLiteral(resourceName: "test.jpg"), time: "\(minutesToPrepare ?? 0)", cooking: "\(minutesToCook ?? 0)")]
            
            if index < 4 {
                let fbr = self.fireBaseRecipes[index]
                self.mockData[index] = ((name: fbr.name, shortDescription: fbr.shortDescription ,image: fbr.image, time:  fbr.time, cooking: fbr.cooking))
                    
                
            }
            index += 1
            self.kolodaView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mockData += [(name: "DefaultRecipe", shortDescription: "RefaultRecipeDescription", image: #imageLiteral(resourceName: "DefaulRecipeImage"),time: "∞",cooking: "∞")]
        mockData += [(name: "DefaultRecipe", shortDescription: "RefaultRecipeDescription", image: #imageLiteral(resourceName: "DefaulRecipeImage"),time: "∞",cooking: "∞")]
        mockData += [(name: "DefaultRecipe", shortDescription: "RefaultRecipeDescription", image: #imageLiteral(resourceName: "DefaulRecipeImage"),time: "∞",cooking: "∞")]
        mockData += [(name: "DefaultRecipe", shortDescription: "RefaultRecipeDescription", image: #imageLiteral(resourceName: "DefaulRecipeImage"),time: "∞",cooking: "∞")]
        mockData += [(name: "DefaultRecipe", shortDescription: "RefaultRecipeDescription", image: #imageLiteral(resourceName: "DefaulRecipeImage"),time: "∞",cooking: "∞")]
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        kolodaView.layer.cornerRadius = 5
        kolodaView.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullRecipe" {
            print("Hello")
            //let navigationController = segue.destination as! UINavigationController
            //let targetController = navigationController.topViewController as? FullRecipeViewController
            if let nextViewController = segue.destination as? FullRecipeViewController {
                nextViewController.name = self.mockData[self.kolodaView.currentCardIndex].name
            }
            //targetController?.image?.image = self.mockData[self.kolodaView.currentCardIndex].image
        }
    }
}

extension ExploreController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {

        kolodaView.resetCurrentCardIndex()
        kolodaView.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        // When clicked on the recipe, needs to go to screen for it.
        performSegue(withIdentifier: "fullRecipe", sender: nil)
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
        let data = mockData[index]
        
        swiper.caption = data.name
        swiper.image = data.image
        swiper.shorDescription = data.shortDescription
        swiper.time = data.time + "'"
        swiper.cooking = data.cooking + "'"
        return swiper
        //return UIImageView(image: #imageLiteral(resourceName: "info.png"))
    }
     
    //func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //    return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    //}
}

//
//  ExploreController.swift
//  Recipe
//
//  Created by Atanas Kurtakov on 29.01.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import Foundation;
import UIKit;
import Koloda;

class ExploreController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    var mockData: [(name: String, image: UIImage, time:  String, cooking: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mockData += [(name: "Soup",image: #imageLiteral(resourceName: "test.jpg"),time: "20",cooking: "30")]
        mockData += [(name: "Cornflake",image: #imageLiteral(resourceName: "test2.jpg"),time: "40",cooking: "60")]
        mockData += [(name: "Pasta and noodles",image: #imageLiteral(resourceName: "test3.png"),time: "80",cooking: "35")]
        mockData += [(name: "Veggie Enchiladas",image: #imageLiteral(resourceName: "test4.jpg"),time: "50",cooking: "55")]
        mockData += [(name: "Salad",image: #imageLiteral(resourceName: "test5.jpg"),time: "30",cooking: "50")]
        
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
        print("OK")
        kolodaView.reloadData()
        
        /*let position = kolodaView.currentCardIndex
        for i in 0...4 {
            mockData.append(mockData[i])
        }

        kolodaView.insertCardAtIndexRange(position..<position + 5, animated: true)
        Add more cards...
        */
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        // When clicked on the recipe, needs to go to screen for it.
        performSegue(withIdentifier: "fullRecipe", sender: nil)
        //prepare(for: , sender: <#T##Any?#>)
        
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
        swiper.time = data.time + "'"
        swiper.cooking = data.cooking + "'"
        return swiper
        //return UIImageView(image: #imageLiteral(resourceName: "info.png"))
    }
     
    //func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //    return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)[0] as? OverlayView
    //}
}

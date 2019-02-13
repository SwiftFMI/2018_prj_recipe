//
//  SwipeCardView.swift
//  Recipe
//
//  Created by Georgi Stoilov on 12.02.19.
//  Copyright © 2019 Mihail Kirilov. All rights reserved.
//

import UIKit

class SwipeCardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    @IBOutlet weak var minutesLabel: UILabel!
    
    @IBOutlet weak var cookingLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "SwipeCardView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    var caption: String? {
        get { return recipeTitle?.text }
        set { recipeTitle.text = newValue }
    }
    
    var image: UIImage? {
        get { return recipeImage.image }
        set { recipeImage.image = newValue }
    }
    
    var time: String? {
        get { return minutesLabel?.text }
        set { minutesLabel.text = newValue }
    }
    
    var cooking: String? {
        get { return cookingLabel?.text }
        set { cookingLabel?.text = newValue }
    }
}

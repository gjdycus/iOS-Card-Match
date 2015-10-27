//
//  Card.swift
//  Match
//
//  Created by Garrett Dycus on 2/28/15.
//  Copyright (c) 2015 Garrett Dycus. All rights reserved.
//

import UIKit

class Card: UIView {

    var cardImageView:UIImageView = UIImageView()
    var cardValue:Int = 0
    var cardNames:[String] = ["ace", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "jack", "queen", "king"]
    var isFlipped:Bool = false
    var isDone:Bool = false {
        didSet {
            //If the card is done, then remove the image
            if (isDone == true) {
                self.cardImageView.image = nil
            }
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        //Set the default image for the image view
        self.cardImageView.image = UIImage(named: "back")
        
        //Set translates autoresizingmask to false
        self.cardImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Add the image view to the view
        self.addSubview(self.cardImageView)
        
        //Set constraints for the image view
        let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.cardImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
        
        let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.cardImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
        
        self.cardImageView.addConstraints([heightConstraint, widthConstraint])
        
        //Set position of the image view
        let topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.cardImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let rightMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.cardImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.addConstraints([topMarginConstraint, rightMarginConstraint])
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func flipUp() {
        //Set imageview to image that represents the card value
        self.cardImageView.image = UIImage(named: self.cardNames[self.cardValue])
        
        self.isFlipped = true
    }
    
    func flipDown() {
        self.cardImageView.image = UIImage(named: "back")
        
        self.isFlipped = false
    }
    
    func eliminate() {
        self.cardImageView.image = nil
    }
    
}
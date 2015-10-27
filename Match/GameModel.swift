//
//  GameModel.swift
//  Match
//
//  Created by Garrett Dycus on 2/28/15.
//  Copyright (c) 2015 Garrett Dycus. All rights reserved.
//

import UIKit

class GameModel: NSObject {

    func getCards() -> [Card] {
        
        var generatedCards:[Card] = [Card]()
        
        //Generate card objects
        for _ in 0...7 {
            
            //Generate random number for card number
            let cardNumber:Int = Int(arc4random_uniform(13))
            
            //Create new card object
            let firstCard:Card = Card()
            firstCard.cardValue = cardNumber
            
            //Create its pair
            let secondCard:Card = Card()
            secondCard.cardValue = cardNumber
            
            //Place card objects into the array
            generatedCards += [firstCard, secondCard]
        }
        
        //Randomize the cards
        for index in 0...generatedCards.count-1 {
            
            //Current card
            let currentCard:Card = generatedCards[index]
            
            //Randomly choose another index
            let randomIndex:Int = Int(arc4random_uniform(16))
            
            //Swap the indexes
            generatedCards[index] = generatedCards[randomIndex]
            generatedCards[randomIndex] = currentCard
        }
        
         return generatedCards
        
    }
    
    
}

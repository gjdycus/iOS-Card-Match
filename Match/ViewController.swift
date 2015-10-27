//
//  ViewController.swift
//  Match
//
//  Created by Garrett Dycus on 2/28/15.
//  Copyright (c) 2015 Garrett Dycus. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var cardScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var result: UILabel!

    
    
    var gameModel:GameModel = GameModel()
    var cards:[Card] = [Card]()
    var revealedCard: Card?
    
    //Timer properties
    var timer: NSTimer!
    var countdown:Int = 20
    
    //Audio player properties
    var correctSound:AVAudioPlayer?
    var incorrectSound:AVAudioPlayer?
    var shuffleCards:AVAudioPlayer?
    var flipCard:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Initialize the audio player
        let correctSoundURL:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingcorrect", ofType: "wav")!)
        if correctSoundURL != nil {
            do {
                self.correctSound = try AVAudioPlayer(contentsOfURL: correctSoundURL!)
            } catch _ {
                self.correctSound = nil
            }
        }
        
        let wrongSoundURL:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingwrong", ofType: "wav")!)
        if wrongSoundURL != nil {
            do {
                self.incorrectSound = try AVAudioPlayer(contentsOfURL: wrongSoundURL!)
            } catch _ {
                self.incorrectSound = nil
            }
        }
        
        let shuffleSoundURL:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("shuffle", ofType: "wav")!)
        if shuffleSoundURL != nil {
            do {
                self.shuffleCards = try AVAudioPlayer(contentsOfURL: shuffleSoundURL!)
            } catch _ {
                self.shuffleCards = nil
            }
        }
        
        let flipCardURL:NSURL? = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cardflip", ofType: "wav")!)
        if flipCardURL != nil {
            do {
                self.flipCard = try AVAudioPlayer(contentsOfURL: flipCardURL!)
            } catch _ {
                self.flipCard = nil
            }
        }
        

        //Get the cards from game model
        self.cards = self.gameModel.getCards()
        
        //Layout the cards
        self.layoutCards()
        
        //Play shuffle sound
        if self.shuffleCards != nil {
        self.shuffleCards?.play()
        }
        
        //Start timer
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
        
         self.result.textColor = UIColor.clearColor()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerUpdate() {
        
        //Decrement the counter
        countdown--
        
        //Update countdown label
        self.time.text = String(countdown)
        
        if countdown == 0 {
            //Game is over, check if all cards have been matched
            var allCardsMatched: Bool = true
            
            //Stop the timer
            self.timer.invalidate()
        
        for card in self.cards {
            
            if card.isDone == false {
                allCardsMatched = false
                break;
            }
            
        }
            var alertText:String = ""
        if allCardsMatched == true {
            //Win
            alertText = "You win!"
            
            self.result.textColor = UIColor.blackColor()
            self.result.text = String("You win!")
        }
        else {
            //Lose
            alertText = "You lose."
            for card in self.cards {
                
                card.eliminate()
            }
            let alert:UIAlertController = UIAlertController(title: "Time's up!", message: alertText, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.result.textColor = UIColor.blackColor()
            self.result.text = String("You lose.")
        }
    }
}
    
    func layoutCards() {
    
        var columnCounter:Int = 0
        var rowCounter:Int = 0
        
        //Loop through each card in the array
        for index in 0...self.cards.count-1 {
            
            //Place the card in the view and turn off translateautoresizingmask
            let thisCard:Card = self.cards[index]
            thisCard.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(thisCard)
            
            let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("cardTapped:"))
            thisCard.addGestureRecognizer(tapGestureRecognizer)
            //thisCard.userInteractionEnabled = true
            
            //Set the height and width constraints
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
            
            thisCard.addConstraints([heightConstraint, widthConstraint])
            
            //Set the horizontal position
            if columnCounter > 0 {
                //Card is not in the first column
                let cardOnTheLeft:Card = self.cards[index-1]
                
                let leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTheLeft, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 5)
                
                //Add constraint
                self.contentView.addConstraint(leftMarginConstraint)
                
            }
            else {
                //Card is in the first column
                let leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
                
                //Add constraint
                self.contentView.addConstraint(leftMarginConstraint)
            }
            
            //Set the vertical position
            if rowCounter > 0 {
                //Card is not in the first row
                let cardOnTop:Card = self.cards[index-4]
                
                let topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTop, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
                
                //Add constraint
                self.contentView.addConstraint(topMarginConstraint)
            }
            else {
                //Card is in the first row
                let topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
                
                self.contentView.addConstraint(topMarginConstraint)
            }
            
            //Increment the counter
            columnCounter++
            if columnCounter >= 4 {
                columnCounter = 0
                rowCounter++
            }
            
        }//End for loop
        
        //Add height constraint to the content view to tell scroll view how much to allow to scroll
        let contentViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.cards[0], attribute: NSLayoutAttribute.Height, multiplier: 4, constant: 35)
        
        let contentViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.cards[0], attribute: NSLayoutAttribute.Width, multiplier: 4, constant: 15)
        
        self.contentView.addConstraints([contentViewHeight, contentViewWidth])
        
    }//End layout function

    func cardTapped(recognizer:UITapGestureRecognizer) {
        
        if self.countdown == 0 {
            return
        }
        
        //Get the card that was tapped
        let cardThatWasTapped:Card = recognizer.view as! Card
        
        //Is the card already flipped up?
        if cardThatWasTapped.isFlipped == false {
            
            //Play flip sound
            if self.flipCard != nil {
                self.flipCard?.play()
            }
            
            //Card is not flipped, now check if it is the first card being flipped
            if self.revealedCard == nil {
                //This is the first card being flipped
                //Flip down all cards
                self.flipDownAllCards()
                
                //Flip up the card
                cardThatWasTapped.flipUp()
                
                //Set the revealed card
                self.revealedCard = cardThatWasTapped
            }
            else {
                //This is the second card being flipped
                
                //Flip up card
                cardThatWasTapped.flipUp()
                
                
                //Check if it's a match
                if (self.revealedCard?.cardValue == cardThatWasTapped.cardValue) {
                    
                    //It's a match
                    //Play correct sound
                    if self.correctSound != nil {
                    self.correctSound?.play()
                    }
                    
                    //Remove both cards
                    self.revealedCard?.isDone = true
                    cardThatWasTapped.isDone = true
                    
                    //Reset the revealed card
                    self.revealedCard = nil
                }
                else {
                    //It's not a match
                    //Play incorrect sound
                    if self.incorrectSound != nil {
                    self.incorrectSound?.play()
                    }
                    
                    //Reset revealed card
                    self.revealedCard = nil
                }
            }
            
        }
        
    } //End func cardTapped

    func flipDownAllCards() {
        
        for card in self.cards {
            
            if card.isDone == false {
                
            card.flipDown()
            }
        }
        
    }
}


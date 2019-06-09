//
//  ViewController.swift
//  SetGame
//
//  Created by Kwangwon Yi on 5/18/19.
//  Copyright © 2019 Kwangwon Yi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        // Set a Timer
        timer.invalidate()
        competeWithAPhone()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        game.addThreeMoreCards()
        updateViewFromModel()
    }
    
    @IBOutlet weak var newButton: UIButton!
    
    @IBAction func newGame(_ sender: UIButton) {
        for button in cardButtons {
            button.titleLabel?.text = ""
        }
        game = SetGame()
        updateViewFromModel()
        
        // Set a new Timer
        timer.invalidate()
        competeWithAPhone()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var visibleCardsCounter: UILabel!
    
    @IBOutlet weak var originalDeckCounter: UILabel!
    
    @IBOutlet weak var hintLabel: UIButton!
    
    @IBAction func getHint(_ sender: UIButton) {
        game.getHint()
        updateViewFromModel()
    }
    
    @IBOutlet weak var timerView: UIProgressView!
    
    private func competeWithAPhone() {
        timerView.progress = 1.0
        timerView.progressTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timerView.progress -= 0.01
        if timerView.progress < 0.5 {
            timerView.progressTintColor = UIColor.red
        } else {
            timerView.progressTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        if timerView.progress == 0 {
            timerView.progressTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            timerView.progress = 1
            game.score -= 1  // Setting it false here is not MVC?
            updateViewFromModel()
        }
    }
    
    private func showToast() {
        let toastLabel = ToastLabel()
        toastLabel.frame = CGRect(x: 0, y: view.frame.height-100, width: view.frame.width-50, height: 0)
        toastLabel.text = "Match! Keep Playing!"
        toastLabel.textAlignment = .center
        toastLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        toastLabel.sizeToFit()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1
        toastLabel.layer.cornerRadius = 8.0
        toastLabel.clipsToBounds = true
        toastLabel.frame.origin.x = (view.frame.width/2) - (toastLabel.frame.width/2)
        toastLabel.frame.origin.y = view.frame.height/13
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0}) {
            (isCompleted) in toastLabel.removeFromSuperview()
        }
    }
    
    private func updateViewFromModel() {
        newButton.layer.cornerRadius = 8.0
        dealButton.layer.cornerRadius = 8.0
        scoreLabel.layer.cornerRadius = 8.0
        scoreLabel.layer.masksToBounds = true
        hintLabel.layer.cornerRadius = 8.0
        scoreLabel.text = "Score: \(game.score)"
        visibleCardsCounter.text = "V: \(game.visibleCards.count)"
        originalDeckCounter.text = "O: \(game.cards.count)"
        
        // Show the toast message when matching and
        // Reset the timer view
        if game.matchStatus {
            if game.toastStatus {
                showToast()
                game.toastStatus = false  // Setting it false here is not MVC?
            }
            timer.invalidate()
            competeWithAPhone()
            game.matchStatus = false  // Setting it false here is not MVC?
        }
        
        if game.visibleCards.count > 23 {
            dealButton.isHidden = true
        } else {
            dealButton.isHidden = false
        }
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.layer.cornerRadius = 8.0
            
            // set the button visible
            if index < game.visibleCards.count {
                button.alpha = 1
                let card = game.visibleCards[index]
                
                // set attributed string
                let attributed :[NSAttributedStringKey:Any]
                if shade(for: card) == "empty" {
                    attributed = [
                        .strokeWidth : 2,
                        .strokeColor : color(for: card)
                    ]
                } else if shade(for: card) == "stripe" {
                    attributed = [
                        .strokeWidth : -1.0,
                        .foregroundColor: UIColor.withAlphaComponent(color(for: card))(0.3)
                    ]
                } else {
                    attributed = [
                        .strokeWidth : -1.0,
                        .foregroundColor: UIColor.withAlphaComponent(color(for: card))(1.0)]
                }
                
                // set the attributed string for various title
                let attributedTitle = NSAttributedString(string: String(repeating: symbol(for: card), count: number(for: card)), attributes: attributed)
                button.setAttributedTitle(attributedTitle, for: UIControlState.normal)
                
                // if the card is selected
                if card.isSelected {
                    button.layer.borderWidth = 2
                    button.layer.borderColor = #colorLiteral(red: 0.5919365287, green: 0.4010326564, blue: 1, alpha: 1)
                } else {
                    button.layer.borderWidth = 0
                }
                // then process to remove matched cards
                // HERE
                if card.isMatched && game.cards.count == 0 {
                    button.alpha = 0
                }
            } else {
                button.alpha = 0
            }
        }
    }
    
    private func number(for card: Card) -> Int {
        switch card.number {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        }
    }
    
    private func symbol(for card: Card) -> String {
        switch card.symbol {
        case .one: return "■"
        case .two: return "▲"
        case .three: return "●"
        }
    }
    
    // TODO: Implement this shade function
    private func shade(for card: Card) -> String {
        switch card.shade {
        case .one: return "empty"
        case .two: return "stripe"
        case .three: return "filled"
        }
    }
    
    private func color(for card: Card) -> UIColor {
        switch card.color {
        case .one: return UIColor.red
        case .two: return UIColor.blue
        case .three: return #colorLiteral(red: 0, green: 0.8655150533, blue: 0, alpha: 1)
        }
    }
}


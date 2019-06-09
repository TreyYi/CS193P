//
//  SetGame.swift
//  SetGame
//
//  Created by Kwangwon Yi on 5/18/19.
//  Copyright © 2019 Kwangwon Yi. All rights reserved.
//

import Foundation

struct SetGame {
    
    private(set) var cards = [Card]()
    var toastStatus = false
    var matchStatus = false
    var visibleCards = [Card]()
    var selectedCards = [Int]()
    var indexOfOneSelectedCard: Int?
    var score = 0
    
    mutating func chooseCard(at index: Int) {
        print(selectedCards)
        // Matching logic
        if selectedCards.count == 3 {
            if checkMatcing(at: selectedCards) {
                print("MATCHING!")
                matchStatus = true
                score += 5
                for index in selectedCards {
                    visibleCards[index].isMatched = true
                }
                // replace the matched cards
                if cards.count > 0 {
                    for replace_index in selectedCards {
                        if let newCardToReplace = getOneRandomCardFromDeck() {
                            visibleCards[replace_index] = newCardToReplace
                        }
                    }
                }
                selectedCards.removeAll()
            } else {
                score -= 1
                matchStatus = false
                for index in selectedCards {
                    visibleCards[index].isSelected = false
                }
                selectedCards.removeAll()
            }
        }
        
        // Save three distinct selected cards
        if selectedCards.count < 3 {
            if !selectedCards.contains(index) {
                visibleCards[index].isSelected = true
                selectedCards.append(index)
            }
            // Unselect the card chosen previously
            if let ownIndex = indexOfOneSelectedCard, ownIndex == index {
                visibleCards[index].isSelected = false
                selectedCards.remove(object: index)
            } else {
                indexOfOneSelectedCard = index
            }
        }
        
        //        // Remove three matched cards
        //        for index in visibleCards.indices {
        //            if visibleCards[index].isMatched {
        //                visibleCards.remove(at: index)
        //            }
        //        }
        
        // Set toast status to be true
        if matchStatus {
            toastStatus = true
        }
    }
    
    func checkMatcing(at _cards: [Int]) -> Bool {
        // check four properties of selected cards
        let isNumberMatched = checkProperty(card1: visibleCards[_cards[0]].number, card2: visibleCards[_cards[1]].number, card3: visibleCards[_cards[2]].number)
        let isSymbolMatched = checkProperty(card1: visibleCards[_cards[0]].symbol, card2: visibleCards[_cards[1]].symbol, card3: visibleCards[_cards[2]].symbol)
        let isShadeMatched = checkProperty(card1: visibleCards[_cards[0]].shade, card2: visibleCards[_cards[1]].shade, card3: visibleCards[_cards[2]].shade)
        let isColorMatched = checkProperty(card1: visibleCards[_cards[0]].color, card2: visibleCards[_cards[1]].color, card3: visibleCards[_cards[2]].color)
        
        if isNumberMatched && isSymbolMatched && isShadeMatched && isColorMatched {
            return true
        } else {
            return false
        }
    }
    
    func checkProperty(card1: Card.Variant, card2: Card.Variant, card3: Card.Variant) -> Bool {
        var isPropertyMatched = false
        
        if card1 == card2 && card2 == card3 {
            isPropertyMatched = true
            return isPropertyMatched
        }
        else if card1 != card2 && card2 != card3 && card1 != card3 {
            isPropertyMatched = true
            return isPropertyMatched
        }
        else {
            // when they are not matched
            return isPropertyMatched
        }
    }
    
    mutating func addThreeMoreCards() {
        for _ in 1...3 {
            if let card = getOneRandomCardFromDeck() {
                visibleCards.append(card)
            }
        }
    }
    
    mutating func getOneRandomCardFromDeck() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
    mutating func getHint() {
        var randomizedHint = [[Int]]()
        
        // Fisrtly, unselect all the button selected previously
        for index in visibleCards.indices {
            visibleCards[index].isSelected = false
        }
        
        // Secondly, remove selected cards array
        if selectedCards.count > 0 {
            selectedCards.removeAll()
        }
        
        // Lastly, check for a hint
        outerLoop: for index in 0...visibleCards.count-3{
            if index < visibleCards.count-3 {
                for index1 in index+1...visibleCards.count-2 {
                    if index1 < visibleCards.count-3 {
                        for index2 in index1+1...visibleCards.count-1 {
                            if visibleCards[index].isMatched || visibleCards[index1].isMatched || visibleCards[index2].isMatched {
                                continue
                            } else {
                                let isNumberMatched = checkProperty(card1: visibleCards[index].number, card2: visibleCards[index1].number, card3: visibleCards[index2].number)
                                let isSymbolMatched = checkProperty(card1: visibleCards[index].symbol, card2: visibleCards[index1].symbol, card3: visibleCards[index2].symbol)
                                let isShadeMatched = checkProperty(card1: visibleCards[index].shade, card2: visibleCards[index1].shade, card3: visibleCards[index2].shade)
                                let isColorMatched = checkProperty(card1: visibleCards[index].color, card2: visibleCards[index1].color, card3: visibleCards[index2].color)
                                
                                if isNumberMatched && isSymbolMatched && isShadeMatched && isColorMatched, !(visibleCards[index].isMatched && visibleCards[index1].isMatched && visibleCards[index2].isMatched) {
                                    randomizedHint.append([index,index1,index2])
                                }
                            }
                        }
                    }
                }
            }
        }
        randomizedHint.shuffle()
        if randomizedHint.count > 0 {
            let indiceOfMatchedCards = randomizedHint.remove(at: randomizedHint.count.arc4random)
            for index in indiceOfMatchedCards {
                visibleCards[index].isSelected = true
            }
            score -= 2
        }
    }
    
    init() {
        // create initial cards deck
        for number in Card.Variant.all {
            for symbol in Card.Variant.all {
                for shade in Card.Variant.all {
                    for color in Card.Variant.all {
                        cards.append(Card(isMatched: false, isSelected: false, number: number, symbol: symbol, shade: shade, color: color))
                    }
                }
            }
        }
        
        // set visible cards
        for _ in 1...12 {
            if let card = getOneRandomCardFromDeck() {
                visibleCards.append(card)
            }
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = index(of: object) else {return}
        remove(at: index)
    }
}

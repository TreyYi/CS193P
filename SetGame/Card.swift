//
//  Card.swift
//  SetGame
//
//  Created by Kwangwon Yi on 5/18/19.
//  Copyright © 2019 Kwangwon Yi. All rights reserved.
//

import Foundation

struct Card
{
    var isMatched = false
    var isSelected = false
    
    var number: Variant
    var symbol: Variant
    var shade: Variant
    var color: Variant
    
    enum Variant {
        case one
        case two
        case three
        
        static var all = [Variant.one,.two,.three]
    }
}

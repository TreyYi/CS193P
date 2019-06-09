//
//  ToastLabel.swift
//  SetGame
//
//  Created by Kwangwon Yi on 5/24/19.
//  Copyright © 2019 Kwangwon Yi. All rights reserved.
//

import Foundation
import UIKit

class ToastLabel: UILabel {
    let margin = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, margin))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + margin.left + margin.right
        let height = superSizeThatFits.height + margin.top + margin.bottom
        return CGSize(width: width, height: height)
    }
    
    
}

//
//  IPhone5PropotionSet.swift
//  SOPA
//
//  Created by Raphael Schilling on 20.03.19.
//  Copyright © 2019 David Schilling. All rights reserved.
//

import CoreGraphics
class IPhone6Proportionset: ProportionSet {
    func buttonSize() -> CGFloat {
       return CGFloat(0.13) * size.height
    }
    func levelNumberFontSize() -> CGFloat {
        return size.height * 0.08
    }
    
    func levelNumberPos() -> CGPoint {
        return CGPoint(x: size.height * 0.11, y: size.height * 0.88)
    }
    
    func movesLabelsPos() -> CGPoint {
        return CGPoint(x: size.width * 0.66, y: size.height * 0.181)
    }
    
    func minMovesPos() -> CGPoint {
        return CGPoint(x: movesFontSize() * -2.6, y: size.height * -0.068)
    }
    
    func currentMovesLabelPos() -> CGPoint {
        return CGPoint(x: movesFontSize() * -2.6, y: 0)
    }
    
    func currentMovesNodePos() -> CGPoint {
        return CGPoint(x: movesFontSize() * 2.7, y: 0)
    }
    
    func movesFontSize() -> CGFloat {
        return self.size.height * CGFloat(0.055)

    }
    
    let size: CGSize
    init(size: CGSize) {
        self.size = size
    }
    
    
}

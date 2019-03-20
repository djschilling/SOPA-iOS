//
//  IPhone5PropotionSet.swift
//  SOPA
//
//  Created by Raphael Schilling on 20.03.19.
//  Copyright © 2019 David Schilling. All rights reserved.
//

import CoreGraphics
class IPhone6Proportionset: ProportionSet {

    
    
    //General
    func buttonSize() -> CGFloat { return CGFloat(0.13) * size.height}
    
    //LevelId
    func levelNumberFontSize() -> CGFloat { return size.height * 0.08 }
    
    //LevelChoiceButton
    func levelChoiceSize() -> CGFloat { return size.height * 0.08}
    
    func levelChoicePos() -> CGPoint { return CGPoint(x: size.height * 0.057, y: size.height * 0.91)}
    
    //RestartButton
    func restartButtonPos() -> CGPoint { return CGPoint(x: size.width * 0.2, y: size.height * 0.111) }

    func levelNumberPos() -> CGPoint { return CGPoint(x: size.height * 0.11, y: size.height * 0.88)}

    //LevelMoves
    func movesLabelsPos() -> CGPoint { return CGPoint(x: size.width * 0.66, y: size.height * 0.181)}
    
    func moveLabelsPos2() -> CGPoint { return CGPoint(x: size.width * 0.5, y: size.height * 0.70)}

    func minMovesPos() -> CGPoint { return CGPoint(x: movesFontSize() * -2.6, y: size.height * -0.068)}
    
    func currentMovesLabelPos() -> CGPoint {return CGPoint(x: movesFontSize() * -2.6, y: 0)}
    
    func currentMovesNodePos() -> CGPoint { return CGPoint(x: movesFontSize() * 2.7, y: 0)}
    
    func movesFontSize() -> CGFloat {return self.size.height * CGFloat(0.055)}
    
//Finish
    //Stars
    func starSize() -> CGSize {return CGSize(width: size.width * 0.36, height: size.width * 0.36)}

    func starLRY() -> CGFloat {return CGFloat(0.37) * size.height}
    
    func starMY() -> CGFloat {return CGFloat(0.33) * size.height}
    
    func starLRX() -> CGFloat {return CGFloat(0.555)}

    
    //init
    let size: CGSize
    init(size: CGSize) {
        self.size = size
    }
    
    
}

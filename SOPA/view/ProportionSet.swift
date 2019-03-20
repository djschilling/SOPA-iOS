//
//  ProportionSet.swift
//  SOPA
//
//  Created by Raphael Schilling on 20.03.19.
//  Copyright © 2019 David Schilling. All rights reserved.
//
import CoreGraphics
protocol ProportionSet {
    func buttonSize() -> CGFloat
    
    func movesFontSize() -> CGFloat
    func movesLabelsPos() -> CGPoint
    func minMovesPos() -> CGPoint
    func currentMovesLabelPos() -> CGPoint
    func currentMovesNodePos() -> CGPoint

    func levelNumberFontSize() -> CGFloat
    func levelNumberPos() -> CGPoint


}

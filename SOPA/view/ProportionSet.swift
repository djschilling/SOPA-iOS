//
//  ProportionSet.swift
//  SOPA
//
//  Created by Raphael Schilling on 20.03.19.
//  Copyright © 2019 David Schilling. All rights reserved.
//
import CoreGraphics
protocol ProportionSet {
    //General
    func buttonSize() -> CGFloat
    
    //LevelId
    func levelNumberFontSize() -> CGFloat
    func levelNumberPos() -> CGPoint
    
    //LevelChoiceButton
    func levelChoiceSize() -> CGFloat
    func levelChoicePos() -> CGPoint
    
    
    
    //RestartButton
    func restartButtonPos() -> CGPoint

    
    //LevelMoves
    func movesFontSize() -> CGFloat
    func movesLabelsPos() -> CGPoint
    func minMovesPos() -> CGPoint
    func currentMovesLabelPos() -> CGPoint
    func currentMovesNodePos() -> CGPoint
    
//Finish
    func moveLabelsPos2() -> CGPoint
    //Star
    func starSize() -> CGSize

    func starLRY() -> CGFloat
    func starMY() -> CGFloat
    func starLRX() -> CGFloat





}

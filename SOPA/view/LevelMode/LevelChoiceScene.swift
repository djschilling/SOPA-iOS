//
//  LevelChoiceScene.swift
//  SOPA
//
//  Created by Raphael Schilling on 22.05.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class LevelChoiceScene: SKScene {
    private let levelInfos: [LevelInfo]
    private var levelButtonArea: LevelButtonArea?
    private var menuButton: SpriteButton?
    private var leftArrowButton: SpriteButton?
    private var rightArrowButton: SpriteButton?

    init(size: CGSize, levelService: LevelService) {
        levelInfos = levelService.getLevelInfos()
        super.init(size: size)
        levelButtonArea = LevelButtonArea(size: size, levelInfos: levelInfos, update: update)
        addChild(levelButtonArea!)
        backgroundColor = .black
        addButtons()
        addPageArrows()
        update()
    }

    private func addButtons() {
        let side = min(size.width * 0.095, size.height * 0.07)
        menuButton = SpriteButton(texture: ButtonTextureFactory.makeMinimalBackTexture(side: side), onClick: backToStartMenu)
        menuButton?.position = CGPoint(x: size.width * 0.085, y: size.height * 0.90)
        menuButton?.zPosition = 20
        addChild(menuButton!)
    }

    private func addPageArrows() {
        let arrowSide = min(size.width * 0.16, size.height * 0.13)
        leftArrowButton = SpriteButton(texture: ButtonTextureFactory.makePageArrowTexture(imageNamed: "ArrowLeft", side: arrowSide), onClick: goToPreviousPage)
        leftArrowButton?.position = CGPoint(x: size.width * 0.08, y: size.height * 0.21)
        leftArrowButton?.zPosition = 20
        addChild(leftArrowButton!)

        rightArrowButton = SpriteButton(texture: ButtonTextureFactory.makePageArrowTexture(imageNamed: "ArrowRight", side: arrowSide), onClick: goToNextPage)
        rightArrowButton?.position = CGPoint(x: size.width * 0.92, y: size.height * 0.21)
        rightArrowButton?.zPosition = 20
        addChild(rightArrowButton!)
    }

    private func goToPreviousPage() {
        levelButtonArea?.swipeLeft()
    }

    private func goToNextPage() {
        levelButtonArea?.swipeRight()
    }

    private func backToStartMenu() {
        ResourcesManager.getInstance().storyService?.loadStartMenuScene()
    }

    func update() {
        guard let area = levelButtonArea else {
            leftArrowButton?.isHidden = true
            rightArrowButton?.isHidden = true
            return
        }

        let isFirstPage = area.currentLevelPage == 0
        let isLastPage = area.currentLevelPage >= area.pageCount - 1
        leftArrowButton?.isHidden = isFirstPage
        rightArrowButton?.isHidden = isLastPage || area.pageCount <= 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

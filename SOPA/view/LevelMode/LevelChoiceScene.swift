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
    private var leftButton: EffectSpriteButton?
    private var rightButton: EffectSpriteButton?
    private var menuButton: SpriteButton?

    init(size: CGSize, levelService: LevelService) {
        levelInfos = levelService.getLevelInfos()
        super.init(size: size)
        levelButtonArea = LevelButtonArea(size: size, levelInfos: levelInfos, update: update)
        addChild(levelButtonArea!)
        addButtons()
        //addStatisticsShareButton()
        self.backgroundColor = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)


    }
    
    private func addStatisticsShareButton() {
        let statisticsShareButton = SpriteButton(imageNamed: "StatisticsShare", onClick: shareStatistics)
        statisticsShareButton.size = CGSize(width: size.height * 0.1, height: size.height * 0.1)
        statisticsShareButton.position.x = size.width * 0.5
        statisticsShareButton.position.y = statisticsShareButton.size.height * 0.5
        addChild(statisticsShareButton)
    }
    
    private func shareStatistics() {
        let shareString = LogFileHandler.logger.readLog()
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil);
        let currentViewController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        currentViewController.present(activityViewController, animated: true, completion: nil);
    }
    
    private func addButtons() {
        let buttonSize = size.height * 0.18
        
        menuButton = SpriteButton(imageNamed: "BackP", onClick: backToStartMenu)
        menuButton?.size = CGSize(width: size.height * 0.08, height: size.height * 0.08)
        menuButton?.position = CGPoint(x: size.height * 0.057, y: size.height * 0.91)
        addChild(menuButton!)
        
        leftButton = EffectSpriteButton(imageNamed: "ArrowLeft", onClick: levelButtonArea!.swipeLeft, size: CGSize(width: buttonSize, height: buttonSize))
        leftButton?.position.y = buttonSize
        leftButton?.position.x = buttonSize
        leftButton?.setEnabled(levelButtonArea!.currentLevelPage > 0)
        addChild(leftButton!)
        
        rightButton = EffectSpriteButton(imageNamed: "ArrowRight", onClick: levelButtonArea!.swipeRight, size: CGSize(width: buttonSize, height: buttonSize))
        rightButton?.position.y = buttonSize
        rightButton?.position.x = size.width - buttonSize
        rightButton?.setEnabled(levelButtonArea!.currentLevelPage < levelButtonArea!.pageCount - 1)
        addChild(rightButton!)
        update()
    }
    
    private func backToStartMenu() {
        ResourcesManager.getInstance().storyService?.loadStartMenuScene()
    }
    
    func update() {
        leftButton?.setEnabled(levelButtonArea!.currentLevelPage > 0)
        rightButton?.setEnabled(levelButtonArea!.currentLevelPage < levelButtonArea!.pageCount - 1)
    }
    
    

 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StartMenuScene: SKScene {
    private let background = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)
    private let textColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = background
        addTitle()
        addButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTitle() {
        let title = SKLabelNode(fontNamed: "Optima-Bold")
        title.text = "SOPA"
        title.fontSize = size.height * 0.12
        title.fontColor = textColor
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.78)
        addChild(title)
        
        let subtitle = SKLabelNode(fontNamed: "Optima-Bold")
        subtitle.text = "Choose a mode"
        subtitle.fontSize = size.height * 0.04
        subtitle.fontColor = textColor
        subtitle.position = CGPoint(x: size.width / 2, y: size.height * 0.70)
        addChild(subtitle)
    }
    
    private func addButtons() {
        let horizontalPadding = size.width * 0.10
        let interButtonGap = size.width * 0.06
        let maxButtonWidthFromScreen = (size.width - (horizontalPadding * 2.0) - interButtonGap) / 2.0
        let buttonSize = min(size.height * 0.20, maxButtonWidthFromScreen)
        let iconTextureSize = CGSize(width: buttonSize, height: buttonSize)
        let totalGroupWidth = buttonSize * 2.0 + interButtonGap
        let leftCenterX = (size.width - totalGroupWidth) / 2.0 + buttonSize / 2.0
        let rightCenterX = leftCenterX + buttonSize + interButtonGap
        let buttonCenterY = size.height * 0.42
        
        let levelModeButton = SpriteButton(texture: makeModeTexture(symbolName: "square.grid.2x2", textureSize: iconTextureSize)) {
            ResourcesManager.getInstance().storyService?.loadLevelCoiceScene()
        }
        levelModeButton.position = CGPoint(x: leftCenterX, y: buttonCenterY)
        addChild(levelModeButton)
        
        let levelModeLabel = SKLabelNode(fontNamed: "Optima-Bold")
        levelModeLabel.text = "Level Mode"
        levelModeLabel.fontSize = size.height * 0.035
        levelModeLabel.fontColor = textColor
        levelModeLabel.position = CGPoint(x: 0, y: -buttonSize * 0.70)
        levelModeButton.addChild(levelModeLabel)
        
        let justPlayButton = SpriteButton(texture: makeModeTexture(symbolName: "bolt.fill", textureSize: iconTextureSize)) {
            ResourcesManager.getInstance().storyService?.loadJustPlaySceneFromMenuScene()
        }
        justPlayButton.position = CGPoint(x: rightCenterX, y: buttonCenterY)
        addChild(justPlayButton)
        
        let justPlayLabel = SKLabelNode(fontNamed: "Optima-Bold")
        justPlayLabel.text = "Just Play"
        justPlayLabel.fontSize = size.height * 0.035
        justPlayLabel.fontColor = textColor
        justPlayLabel.position = CGPoint(x: 0, y: -buttonSize * 0.70)
        justPlayButton.addChild(justPlayLabel)
    }
    
    private func makeModeTexture(symbolName: String, textureSize: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: textureSize)
        let image = renderer.image { _ in
            let frame = CGRect(origin: .zero, size: textureSize).insetBy(dx: textureSize.width * 0.05, dy: textureSize.height * 0.05)
            let backgroundPath = UIBezierPath(roundedRect: frame, cornerRadius: textureSize.width * 0.18)
            UIColor(white: 1.0, alpha: 0.10).setFill()
            backgroundPath.fill()
            UIColor(white: 1.0, alpha: 0.22).setStroke()
            backgroundPath.lineWidth = textureSize.width * 0.03
            backgroundPath.stroke()

            let config = UIImage.SymbolConfiguration(pointSize: textureSize.width * 0.44, weight: .semibold)
            if let symbol = UIImage(systemName: symbolName, withConfiguration: config)?
                .withTintColor(textColor, renderingMode: .alwaysOriginal) {
                let symbolRect = CGRect(
                    x: (textureSize.width - symbol.size.width) / 2.0,
                    y: (textureSize.height - symbol.size.height) / 2.0,
                    width: symbol.size.width,
                    height: symbol.size.height
                )
                symbol.draw(in: symbolRect)
            }
        }
        return SKTexture(image: image)
    }
}

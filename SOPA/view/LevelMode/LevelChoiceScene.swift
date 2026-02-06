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

func makeSymbolButtonTexture(symbolName: String, side: CGFloat) -> SKTexture {
    let textureSize = CGSize(width: side, height: side)
    let renderer = UIGraphicsImageRenderer(size: textureSize)
    let image = renderer.image { _ in
        let config = UIImage.SymbolConfiguration(pointSize: side * 0.92, weight: .semibold)
        if let symbol = UIImage(systemName: symbolName, withConfiguration: config)?
            .withTintColor(UIColor(white: 0.94, alpha: 1.0), renderingMode: .alwaysOriginal) {
            symbol.draw(in: CGRect(origin: .zero, size: textureSize))
        }
    }
    return SKTexture(image: image)
}

func makeBackButtonTexture(side: CGFloat) -> SKTexture {
    makeSymbolButtonTexture(symbolName: "chevron.left.circle.fill", side: side)
}

func makeRestartButtonTexture(side: CGFloat) -> SKTexture {
    makeSymbolButtonTexture(symbolName: "arrow.counterclockwise.circle.fill", side: side)
}

func makeNextButtonTexture(side: CGFloat) -> SKTexture {
    makeSymbolButtonTexture(symbolName: "chevron.right.circle.fill", side: side)
}

class LevelChoiceScene: SKScene {
    private let levelInfos: [LevelInfo]
    private var levelButtonArea: LevelButtonArea?
    private var menuButton: SpriteButton?

    init(size: CGSize, levelService: LevelService) {
        levelInfos = levelService.getLevelInfos()
        super.init(size: size)
        levelButtonArea = LevelButtonArea(size: size, levelInfos: levelInfos, update: update)
        addChild(levelButtonArea!)
        addButtons()
        self.backgroundColor = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)


    }
    
    private func addButtons() {
        let side = size.height * 0.08
        menuButton = SpriteButton(texture: makeBackButtonTexture(side: side), onClick: backToStartMenu)
        menuButton?.position = CGPoint(x: size.height * 0.057, y: size.height * 0.91)
        addChild(menuButton!)
    }
    
    private func backToStartMenu() {
        ResourcesManager.getInstance().storyService?.loadStartMenuScene()
    }
    
    func update() {
        // Intentionally empty: level paging is swipe-only.
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

        let utilityButtonY = size.height * 0.20
        let utilityButtonSize = CGSize(width: size.width * 0.30, height: size.height * 0.075)
        let utilityGap = size.width * 0.04
        let totalUtilityWidth = utilityButtonSize.width * 2.0 + utilityGap
        let firstUtilityX = (size.width - totalUtilityWidth) / 2.0 + utilityButtonSize.width / 2.0

        let tutorialButton = SpriteButton(texture: makeTextButtonTexture(title: "Tutorial", size: utilityButtonSize)) {
            ResourcesManager.getInstance().storyService?.loadTutorialSceneFromMenuScene()
        }
        tutorialButton.position = CGPoint(x: firstUtilityX, y: utilityButtonY)
        addChild(tutorialButton)

        let creditsButton = SpriteButton(texture: makeTextButtonTexture(title: "Credits", size: utilityButtonSize)) {
            ResourcesManager.getInstance().storyService?.loadCreditsSceneFromMenuScene()
        }
        creditsButton.position = CGPoint(x: firstUtilityX + utilityButtonSize.width + utilityGap, y: utilityButtonY)
        addChild(creditsButton)
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

    private func makeTextButtonTexture(title: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let frame = CGRect(origin: .zero, size: size).insetBy(dx: size.width * 0.01, dy: size.height * 0.04)
            let backgroundPath = UIBezierPath(roundedRect: frame, cornerRadius: size.height * 0.25)
            UIColor(white: 1.0, alpha: 0.10).setFill()
            backgroundPath.fill()
            UIColor(white: 1.0, alpha: 0.22).setStroke()
            backgroundPath.lineWidth = size.height * 0.07
            backgroundPath.stroke()

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Optima-Bold", size: size.height * 0.40) ?? UIFont.systemFont(ofSize: size.height * 0.40, weight: .semibold),
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            let textRect = CGRect(x: 0.0, y: size.height * 0.28, width: size.width, height: size.height * 0.5)
            title.draw(in: textRect, withAttributes: attributes)
        }
        return SKTexture(image: image)
    }
}

class CreditsScene: SKScene {
    private let background = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)
    private let textColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)

    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = background
        addBackButton()
        addTitle()
        addLines()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addBackButton() {
        let side = size.height * 0.08
        let backButton = SpriteButton(texture: makeBackButtonTexture(side: side)) {
            ResourcesManager.getInstance().storyService?.loadStartMenuScene()
        }
        backButton.position = CGPoint(x: size.height * 0.057, y: size.height * 0.91)
        addChild(backButton)
    }

    private func addTitle() {
        let title = SKLabelNode(fontNamed: "Optima-Bold")
        title.text = "Credits"
        title.fontSize = size.height * 0.10
        title.fontColor = textColor
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.78)
        addChild(title)
    }

    private func addLines() {
        addLine(text: "Design and Development", y: size.height * 0.62, sizeFactor: 0.038)
        addLine(text: "David Schilling", y: size.height * 0.55, sizeFactor: 0.048)
        addLine(text: "Raphael Schilling", y: size.height * 0.49, sizeFactor: 0.048)
        addLine(text: "Gameplay and Product Iteration", y: size.height * 0.39, sizeFactor: 0.038)
        addLine(text: "SOPA Team", y: size.height * 0.33, sizeFactor: 0.048)
    }

    private func addLine(text: String, y: CGFloat, sizeFactor: CGFloat) {
        let line = SKLabelNode(fontNamed: "Optima-Bold")
        line.text = text
        line.fontSize = fittedFontSize(for: text, preferredSize: size.height * sizeFactor, maxWidth: size.width * 0.86)
        line.fontColor = textColor
        line.position = CGPoint(x: size.width * 0.5, y: y)
        addChild(line)
    }

    private func fittedFontSize(for text: String, preferredSize: CGFloat, maxWidth: CGFloat) -> CGFloat {
        let label = SKLabelNode(fontNamed: "Optima-Bold")
        label.text = text
        var currentSize = preferredSize
        label.fontSize = currentSize

        while label.frame.width > maxWidth && currentSize > 10.0 {
            currentSize -= 1.0
            label.fontSize = currentSize
        }
        return currentSize
    }
}

class TutorialScene: SKScene {
    private let background = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255, alpha: 1.0)
    private let textColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    private var currentPage = 0
    private let headline = SKLabelNode(fontNamed: "Optima-Bold")
    private let textLine1 = SKLabelNode(fontNamed: "Optima-Bold")
    private let textLine2 = SKLabelNode(fontNamed: "Optima-Bold")
    private let textLine3 = SKLabelNode(fontNamed: "Optima-Bold")
    private let tapHint = SKLabelNode(fontNamed: "Optima-Bold")
    private var letsGoButton: SpriteButton?

    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = background
        addBackButton()
        addTitle()
        addContentNodes()
        updatePage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addBackButton() {
        let side = size.height * 0.08
        let backButton = SpriteButton(texture: makeBackButtonTexture(side: side)) {
            ResourcesManager.getInstance().storyService?.loadStartMenuScene()
        }
        backButton.position = CGPoint(x: size.height * 0.057, y: size.height * 0.91)
        addChild(backButton)
    }

    private func addTitle() {
        let title = SKLabelNode(fontNamed: "Optima-Bold")
        title.text = "Tutorial"
        title.fontSize = size.height * 0.10
        title.fontColor = textColor
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.78)
        addChild(title)
    }

    private func addContentNodes() {
        headline.fontColor = textColor
        headline.fontSize = size.height * 0.048
        headline.position = CGPoint(x: size.width * 0.5, y: size.height * 0.62)
        addChild(headline)

        textLine1.fontColor = textColor
        textLine1.fontSize = size.height * 0.034
        textLine1.position = CGPoint(x: size.width * 0.5, y: size.height * 0.54)
        addChild(textLine1)

        textLine2.fontColor = textColor
        textLine2.fontSize = size.height * 0.034
        textLine2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.48)
        addChild(textLine2)

        textLine3.fontColor = textColor
        textLine3.fontSize = size.height * 0.034
        textLine3.position = CGPoint(x: size.width * 0.5, y: size.height * 0.42)
        addChild(textLine3)

        tapHint.fontColor = textColor
        tapHint.fontSize = size.height * 0.030
        tapHint.position = CGPoint(x: size.width * 0.5, y: size.height * 0.26)
        addChild(tapHint)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentPage < 2 {
            currentPage += 1
            updatePage()
        }
    }

    private func updatePage() {
        switch currentPage {
        case 0:
            setPage(
                headlineText: "Goal",
                line1: "Connect the start and finish pipes.",
                line2: "Swipe rows or columns to move tiles.",
                line3: "Only matching pipe segments will connect.",
                hint: "Tap anywhere to continue"
            )
            letsGoButton?.isHidden = true
        case 1:
            setPage(
                headlineText: "How It Works",
                line1: "Horizontal swipe moves a full row.",
                line2: "Vertical swipe moves a full column.",
                line3: "Try to solve it in as few moves as possible.",
                hint: "Tap anywhere to continue"
            )
            letsGoButton?.isHidden = true
        default:
            setPage(
                headlineText: "Try It Now",
                line1: "Next you play a simple interactive level.",
                line2: "Use restart if you want to try again.",
                line3: "",
                hint: ""
            )
            ensureLetsGoButton()
            letsGoButton?.isHidden = false
        }
    }

    private func setPage(headlineText: String, line1: String, line2: String, line3: String, hint: String) {
        headline.text = headlineText
        headline.fontSize = fittedFontSize(for: headlineText, preferredSize: size.height * 0.048, maxWidth: size.width * 0.90)

        textLine1.text = line1
        textLine1.fontSize = fittedFontSize(for: line1, preferredSize: size.height * 0.034, maxWidth: size.width * 0.92)
        textLine2.text = line2
        textLine2.fontSize = fittedFontSize(for: line2, preferredSize: size.height * 0.034, maxWidth: size.width * 0.92)
        textLine3.text = line3
        textLine3.fontSize = fittedFontSize(for: line3, preferredSize: size.height * 0.034, maxWidth: size.width * 0.92)
        tapHint.text = hint
        tapHint.fontSize = fittedFontSize(for: hint, preferredSize: size.height * 0.030, maxWidth: size.width * 0.92)
    }

    private func ensureLetsGoButton() {
        if letsGoButton != nil {
            return
        }

        let buttonSize = CGSize(width: size.width * 0.34, height: size.height * 0.10)
        let button = SpriteButton(texture: makeTextButtonTexture(title: "Let's Go", size: buttonSize)) {
            ResourcesManager.getInstance().storyService?.loadTutorialGameSceneFromTutorialScene()
        }
        button.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        addChild(button)
        letsGoButton = button
    }

    private func makeTextButtonTexture(title: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let frame = CGRect(origin: .zero, size: size).insetBy(dx: size.width * 0.01, dy: size.height * 0.06)
            let backgroundPath = UIBezierPath(roundedRect: frame, cornerRadius: size.height * 0.23)
            UIColor(white: 1.0, alpha: 0.10).setFill()
            backgroundPath.fill()
            UIColor(white: 1.0, alpha: 0.22).setStroke()
            backgroundPath.lineWidth = size.height * 0.08
            backgroundPath.stroke()

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Optima-Bold", size: size.height * 0.42) ?? UIFont.systemFont(ofSize: size.height * 0.42, weight: .semibold),
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            let textRect = CGRect(x: 0.0, y: size.height * 0.28, width: size.width, height: size.height * 0.5)
            title.draw(in: textRect, withAttributes: attributes)
        }
        return SKTexture(image: image)
    }

    private func fittedFontSize(for text: String, preferredSize: CGFloat, maxWidth: CGFloat) -> CGFloat {
        if text.isEmpty {
            return preferredSize
        }
        let label = SKLabelNode(fontNamed: "Optima-Bold")
        label.text = text
        var currentSize = preferredSize
        label.fontSize = currentSize

        while label.frame.width > maxWidth && currentSize > 10.0 {
            currentSize -= 1.0
            label.fontSize = currentSize
        }
        return currentSize
    }
}

class TutorialGameScene: GameScene {
    private var restartButton: SpriteButton?
    private var menuButton: SpriteButton?
    private var finishButton: SpriteButton?
    private let tutorialHint = SKLabelNode(fontNamed: "Optima-Bold")
    private let tutorialSubHint = SKLabelNode(fontNamed: "Optima-Bold")

    override init(size: CGSize, proportionSet: ProportionSet, level: Level) {
        super.init(size: size, proportionSet: proportionSet, level: level)
        addTutorialHints()
        updateHintText()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addStaticLabels() {
        // Tutorial scene keeps UI minimal and avoids overlap with end-of-tutorial CTA.
    }

    override func addDynamicLabels() {
        // No move counters in tutorial.
    }

    override func addButtons() {
        let side = proportionSet.levelChoiceSize()
        restartButton = SpriteButton(texture: makeRestartButtonTexture(side: side), onClick: restartTutorial)
        restartButton!.position = CGPoint(x: size.width - size.height * 0.057, y: size.height * 0.91)
        addChild(restartButton!)

        menuButton = SpriteButton(texture: makeBackButtonTexture(side: side), onClick: backToStartMenu)
        menuButton!.position = proportionSet.levelChoicePos()
        addChild(menuButton!)
    }

    override func moveLine(horizontal: Bool, rowOrColumn: Int, steps: Int) {
        super.moveLine(horizontal: horizontal, rowOrColumn: rowOrColumn, steps: steps)
        if !levelSolved {
            updateHintText()
        }
    }

    override func onSolvedGame() {
        tutorialHint.text = "Solved"
        tutorialHint.fontSize = size.height * 0.06
        tutorialHint.position = CGPoint(x: size.width * 0.5, y: size.height * 0.30)
        tutorialSubHint.text = ""
        showFinishButton()
    }

    private func addTutorialHints() {
        tutorialHint.fontColor = fontColor
        tutorialHint.position = CGPoint(x: size.width * 0.5, y: size.height * 0.24)
        tutorialHint.zPosition = 10
        addChild(tutorialHint)

        tutorialSubHint.fontColor = fontColor
        tutorialSubHint.position = CGPoint(x: size.width * 0.5, y: size.height * 0.19)
        tutorialSubHint.zPosition = 10
        addChild(tutorialSubHint)
    }

    private func updateHintText() {
        if gameService.getLevel().movesCounter == 0 {
            tutorialHint.text = "Swipe any row or column"
            tutorialHint.fontSize = fittedFontSize(for: tutorialHint.text ?? "", preferredSize: size.height * 0.040, maxWidth: size.width * 0.92)
            tutorialSubHint.text = "Connect start and finish in this level."
            tutorialSubHint.fontSize = fittedFontSize(for: tutorialSubHint.text ?? "", preferredSize: size.height * 0.032, maxWidth: size.width * 0.92)
        } else {
            tutorialHint.text = "Good"
            tutorialHint.fontSize = size.height * 0.044
            tutorialSubHint.text = "Keep going until the path is connected."
            tutorialSubHint.fontSize = fittedFontSize(for: tutorialSubHint.text ?? "", preferredSize: size.height * 0.032, maxWidth: size.width * 0.92)
        }
    }

    private func showFinishButton() {
        if finishButton != nil {
            finishButton?.isHidden = false
            return
        }
        let buttonSize = CGSize(width: size.width * 0.62, height: size.height * 0.095)
        finishButton = SpriteButton(texture: makeTextButtonTexture(title: "Back to Menu", size: buttonSize)) {
            ResourcesManager.getInstance().storyService?.loadStartMenuScene()
        }
        finishButton?.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        finishButton?.zPosition = 10
        addChild(finishButton!)
    }

    private func restartTutorial() {
        ResourcesManager.getInstance().storyService?.loadTutorialGameSceneFromTutorialScene()
    }

    private func backToStartMenu() {
        ResourcesManager.getInstance().storyService?.loadStartMenuScene()
    }

    private func makeTextButtonTexture(title: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let frame = CGRect(origin: .zero, size: size).insetBy(dx: size.width * 0.01, dy: size.height * 0.06)
            let backgroundPath = UIBezierPath(roundedRect: frame, cornerRadius: size.height * 0.23)
            UIColor(white: 1.0, alpha: 0.10).setFill()
            backgroundPath.fill()
            UIColor(white: 1.0, alpha: 0.22).setStroke()
            backgroundPath.lineWidth = size.height * 0.08
            backgroundPath.stroke()

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let buttonFontSize = fittedButtonFontSize(for: title, preferredSize: size.height * 0.38, maxWidth: size.width * 0.90)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Optima-Bold", size: buttonFontSize) ?? UIFont.systemFont(ofSize: buttonFontSize, weight: .semibold),
                .foregroundColor: fontColor,
                .paragraphStyle: paragraphStyle
            ]
            let textRect = CGRect(x: 0.0, y: size.height * 0.30, width: size.width, height: size.height * 0.5)
            title.draw(in: textRect, withAttributes: attributes)
        }
        return SKTexture(image: image)
    }

    private func fittedButtonFontSize(for text: String, preferredSize: CGFloat, maxWidth: CGFloat) -> CGFloat {
        var currentSize = preferredSize
        while currentSize > 10.0 {
            let font = UIFont(name: "Optima-Bold", size: currentSize) ?? UIFont.systemFont(ofSize: currentSize, weight: .semibold)
            let measuredWidth = (text as NSString).size(withAttributes: [.font: font]).width
            if measuredWidth <= maxWidth {
                return currentSize
            }
            currentSize -= 1.0
        }
        return 10.0
    }

    private func fittedFontSize(for text: String, preferredSize: CGFloat, maxWidth: CGFloat) -> CGFloat {
        if text.isEmpty {
            return preferredSize
        }
        let label = SKLabelNode(fontNamed: "Optima-Bold")
        label.text = text
        var currentSize = preferredSize
        label.fontSize = currentSize

        while label.frame.width > maxWidth && currentSize > 10.0 {
            currentSize -= 1.0
            label.fontSize = currentSize
        }
        return currentSize
    }
}

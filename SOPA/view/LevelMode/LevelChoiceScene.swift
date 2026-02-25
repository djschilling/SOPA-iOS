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

func makeCircleButtonTexture(symbolName: String, side: CGFloat) -> SKTexture {
    let textureSize = CGSize(width: side, height: side)
    let circleColor = UIColor(white: 0.94, alpha: 1.0)
    let iconColor = UIColor(red: 90.6 / 255.0, green: 86.7 / 255.0, blue: 70.6 / 255.0, alpha: 1.0)
    let renderer = UIGraphicsImageRenderer(size: textureSize)
    let image = renderer.image { _ in
        circleColor.setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: textureSize)).fill()

        let config = UIImage.SymbolConfiguration(pointSize: side * 0.42, weight: .semibold)
        if let symbol = UIImage(systemName: symbolName, withConfiguration: config)?
            .withTintColor(iconColor, renderingMode: .alwaysOriginal) {
            let symbolRect = CGRect(
                x: (side - symbol.size.width) / 2.0,
                y: (side - symbol.size.height) / 2.0,
                width: symbol.size.width,
                height: symbol.size.height
            )
            symbol.draw(in: symbolRect)
        }
    }
    return SKTexture(image: image)
}

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
        menuButton = SpriteButton(texture: makeMenuBackTexture(side: side), onClick: backToStartMenu)
        menuButton?.position = CGPoint(x: size.width * 0.085, y: size.height * 0.90)
        menuButton?.zPosition = 20
        addChild(menuButton!)
    }

    private func makeMenuBackTexture(side: CGFloat) -> SKTexture {
        let textureSize = CGSize(width: side, height: side)
        let renderer = UIGraphicsImageRenderer(size: textureSize)
        let image = renderer.image { _ in
            let config = UIImage.SymbolConfiguration(pointSize: side * 0.72, weight: .semibold)
            if let symbol = UIImage(systemName: "chevron.left", withConfiguration: config)?
                .withTintColor(UIColor(red: 160.0 / 255.0, green: 164.0 / 255.0, blue: 170.0 / 255.0, alpha: 0.95), renderingMode: .alwaysOriginal) {
                let symbolRect = CGRect(
                    x: (side - symbol.size.width) / 2.0,
                    y: (side - symbol.size.height) / 2.0,
                    width: symbol.size.width,
                    height: symbol.size.height
                )
                symbol.draw(in: symbolRect)
            }
        }
        return SKTexture(image: image)
    }

    private func addPageArrows() {
        let arrowSide = min(size.width * 0.16, size.height * 0.13)
        leftArrowButton = SpriteButton(texture: makePageArrowTexture(imageNamed: "ArrowLeft", side: arrowSide), onClick: goToPreviousPage)
        leftArrowButton?.position = CGPoint(x: size.width * 0.08, y: size.height * 0.21)
        leftArrowButton?.zPosition = 20
        addChild(leftArrowButton!)

        rightArrowButton = SpriteButton(texture: makePageArrowTexture(imageNamed: "ArrowRight", side: arrowSide), onClick: goToNextPage)
        rightArrowButton?.position = CGPoint(x: size.width * 0.92, y: size.height * 0.21)
        rightArrowButton?.zPosition = 20
        addChild(rightArrowButton!)
    }

    private func makePageArrowTexture(imageNamed: String, side: CGFloat) -> SKTexture {
        let texture = SKTexture(imageNamed: imageNamed)
        let imageSize = texture.size()
        let ratio = imageSize.width / max(1, imageSize.height)
        let targetSize = CGSize(width: side * ratio, height: side)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: targetSize)
            UIImage(named: imageNamed)?.draw(in: rect)
        }
        return SKTexture(image: image)
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

class StartMenuScene: SKScene {
    private let background = UIColor.black
    private let titleColor = UIColor(red: 214.0 / 255.0, green: 214.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    private let neonColor = UIColor(red: 111.0 / 255.0, green: 227.0 / 255.0, blue: 1.0, alpha: 1.0)
    private let neonGlowColor = UIColor(red: 23.0 / 255.0, green: 183.0 / 255.0, blue: 1.0, alpha: 1.0)
    private let twitterUrl = "https://twitter.com/sopagame"
    private let shareText = "I played SOPA: https://play.google.com/store/apps/details?id=com.sopaapp"

    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = background
        addTitle()
        addButtons()
        addSocialButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTitle() {
        let title = SKLabelNode(fontNamed: "Impact")
        title.text = "SOPA"
        title.fontSize = size.height * 0.14
        title.fontColor = titleColor
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.77)
        addChild(title)
    }

    private func addButtons() {
        let menuItems: [(title: String, action: () -> Void)] = [
            ("LEVEL MODE", { ResourcesManager.getInstance().storyService?.loadLevelCoiceScene() }),
            ("JUST PLAY", { ResourcesManager.getInstance().storyService?.loadJustPlaySceneFromMenuScene() }),
            // Keep this wired until a dedicated Settings scene exists on iOS.
            ("SETTINGS", { ResourcesManager.getInstance().storyService?.loadTutorialSceneFromMenuScene() }),
            ("CREDITS", { ResourcesManager.getInstance().storyService?.loadCreditsSceneFromMenuScene() })
        ]

        let buttonSize = CGSize(width: size.width * 0.76, height: size.height * 0.095)
        let firstY = size.height * 0.62
        let verticalGap = size.height * 0.11

        for (index, item) in menuItems.enumerated() {
            let button = SpriteButton(texture: makeNeonTextTexture(title: item.title, size: buttonSize), onClick: item.action)
            button.position = CGPoint(x: size.width / 2.0, y: firstY - CGFloat(index) * verticalGap)
            addChild(button)
        }
    }

    private func addSocialButtons() {
        let buttonSide = min(size.width * 0.18, size.height * 0.10)

        let shareButton = SpriteButton(
            texture: makeSocialButtonTexture(symbolName: "point.3.connected.trianglepath.dotted", size: CGSize(width: buttonSide, height: buttonSide), fillBackground: true),
            onClick: shareApp
        )
        shareButton.position = CGPoint(x: size.width * 0.20, y: size.height * 0.14)
        addChild(shareButton)

        let twitterButton = SpriteButton(
            texture: makeSocialButtonTexture(symbolName: "paperplane.fill", size: CGSize(width: buttonSide * 1.15, height: buttonSide * 1.15), fillBackground: false),
            onClick: openTwitter
        )
        twitterButton.position = CGPoint(x: size.width * 0.74, y: size.height * 0.14)
        addChild(twitterButton)
    }

    private func makeNeonTextTexture(title: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let glowShadow = NSShadow()
            glowShadow.shadowColor = neonGlowColor
            glowShadow.shadowBlurRadius = size.height * 0.22
            glowShadow.shadowOffset = .zero

            let font = UIFont(name: "HelveticaNeue-Light", size: size.height * 0.60)
                ?? UIFont.systemFont(ofSize: size.height * 0.60, weight: .light)
            let textRect = CGRect(x: 0, y: size.height * 0.22, width: size.width, height: size.height * 0.60)

            let glowAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: neonColor,
                .strokeColor: neonColor,
                .strokeWidth: -1.2,
                .paragraphStyle: paragraphStyle,
                .shadow: glowShadow
            ]
            title.draw(in: textRect, withAttributes: glowAttributes)

            let coreAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor(red: 183.0 / 255.0, green: 245.0 / 255.0, blue: 1.0, alpha: 1.0),
                .paragraphStyle: paragraphStyle
            ]
            title.draw(in: textRect, withAttributes: coreAttributes)
        }
        return SKTexture(image: image)
    }

    private func makeSocialButtonTexture(symbolName: String, size: CGSize, fillBackground: Bool) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let blueColor = UIColor(red: 99.0 / 255.0, green: 177.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
            if fillBackground {
                let backgroundPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: size.width * 0.18)
                blueColor.setFill()
                backgroundPath.fill()
            }

            let pointSize = fillBackground ? size.width * 0.50 : size.width * 0.75
            let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold)
            guard let baseSymbol = UIImage(systemName: symbolName, withConfiguration: config) else {
                return
            }

            let iconColor = fillBackground ? UIColor.white : blueColor
            let symbol = baseSymbol.withTintColor(iconColor, renderingMode: .alwaysOriginal)
            let symbolRect = CGRect(
                x: (size.width - symbol.size.width) / 2.0,
                y: (size.height - symbol.size.height) / 2.0,
                width: symbol.size.width,
                height: symbol.size.height
            )
            symbol.draw(in: symbolRect)
        }
        return SKTexture(image: image)
    }

    private func openTwitter() {
        guard let url = URL(string: twitterUrl) else {
            return
        }
        UIApplication.shared.open(url)
    }

    private func shareApp() {
        guard let controller = topViewController() else {
            return
        }
        let shareController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = controller.view
        controller.present(shareController, animated: true)
    }

    private func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let initialController: UIViewController?
        if let base = base {
            initialController = base
        } else {
            initialController = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?.rootViewController
        }

        if let navController = initialController as? UINavigationController {
            return topViewController(base: navController.visibleViewController)
        }
        if let tabController = initialController as? UITabBarController {
            return topViewController(base: tabController.selectedViewController)
        }
        if let presented = initialController?.presentedViewController {
            return topViewController(base: presented)
        }
        return initialController
    }
}

class CreditsScene: SKScene {
    private let background = UIColor.black
    private let titleColor = UIColor(red: 214.0 / 255.0, green: 214.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    private let sectionColor = UIColor(red: 111.0 / 255.0, green: 227.0 / 255.0, blue: 1.0, alpha: 1.0)
    private let textColor = UIColor(red: 230.0 / 255.0, green: 236.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)

    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = background
        addBackButton()
        addTitle()
        addCreditsContent()
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

    private func makeBackButtonTexture(side: CGFloat) -> SKTexture {
        let textureSize = CGSize(width: side, height: side)
        let renderer = UIGraphicsImageRenderer(size: textureSize)
        let image = renderer.image { _ in
            let frame = CGRect(origin: .zero, size: textureSize)
            let path = UIBezierPath(roundedRect: frame, cornerRadius: side * 0.25)
            UIColor(white: 1.0, alpha: 0.10).setFill()
            path.fill()
            UIColor(white: 1.0, alpha: 0.20).setStroke()
            path.lineWidth = side * 0.05
            path.stroke()

            let config = UIImage.SymbolConfiguration(pointSize: side * 0.44, weight: .bold)
            if let symbol = UIImage(systemName: "chevron.left", withConfiguration: config)?
                .withTintColor(sectionColor, renderingMode: .alwaysOriginal) {
                let symbolRect = CGRect(
                    x: (side - symbol.size.width) / 2.0,
                    y: (side - symbol.size.height) / 2.0,
                    width: symbol.size.width,
                    height: symbol.size.height
                )
                symbol.draw(in: symbolRect)
            }
        }
        return SKTexture(image: image)
    }

    private func addTitle() {
        let title = SKLabelNode(fontNamed: "Impact")
        title.text = "CREDITS"
        title.fontSize = size.height * 0.09
        title.fontColor = titleColor
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.78)
        addChild(title)
    }

    private func addCreditsContent() {
        let content: [(section: String, entries: [String])] = [
            ("DEVELOPMENT", ["David Schilling - @schillda710", "Raphael Schilling - @ubuntius"]),
            ("DESIGN", ["Raphael Schilling - @ubuntius"]),
            ("MUSIC", ["Menu - axtoncrolley on opengameart.org"])
        ]

        var currentY = size.height * 0.70
        for block in content {
            addSectionLine(text: block.section, y: currentY)
            currentY -= size.height * 0.045

            for entry in block.entries {
                addBodyLine(text: entry, y: currentY)
                currentY -= size.height * 0.038
            }
            currentY -= size.height * 0.028
        }
    }

    private func addSectionLine(text: String, y: CGFloat) {
        let line = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        line.horizontalAlignmentMode = .left
        line.verticalAlignmentMode = .center
        line.text = text
        line.fontSize = fittedFontSize(
            for: text,
            fontName: "HelveticaNeue-Bold",
            preferredSize: size.height * 0.032,
            maxWidth: size.width * 0.88
        )
        line.fontColor = sectionColor
        line.position = CGPoint(x: size.width * 0.06, y: y)
        addChild(line)
    }

    private func addBodyLine(text: String, y: CGFloat) {
        let line = SKLabelNode(fontNamed: "HelveticaNeue")
        line.horizontalAlignmentMode = .left
        line.verticalAlignmentMode = .center
        line.text = text
        line.fontSize = fittedFontSize(
            for: text,
            fontName: "HelveticaNeue",
            preferredSize: size.height * 0.026,
            maxWidth: size.width * 0.90
        )
        line.fontColor = textColor
        line.position = CGPoint(x: size.width * 0.09, y: y)
        addChild(line)
    }

    private func fittedFontSize(for text: String, fontName: String, preferredSize: CGFloat, maxWidth: CGFloat) -> CGFloat {
        let label = SKLabelNode(fontNamed: fontName)
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
        let backButton = SpriteButton(texture: makeCircleButtonTexture(symbolName: "chevron.left", side: side)) {
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
        restartButton = SpriteButton(texture: makeCircleButtonTexture(symbolName: "arrow.counterclockwise", side: side), onClick: restartTutorial)
        restartButton!.position = CGPoint(x: size.width - size.height * 0.057, y: size.height * 0.91)
        addChild(restartButton!)

        menuButton = SpriteButton(texture: makeCircleButtonTexture(symbolName: "chevron.left", side: side), onClick: backToStartMenu)
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

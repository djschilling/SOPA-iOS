import Foundation
import SpriteKit
import UIKit

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
            tutorialHint.fontSize = LabelSizing.fittedLabelFontSize(text: tutorialHint.text ?? "", fontName: "Optima-Bold", preferredSize: size.height * 0.040, maxWidth: size.width * 0.92)
            tutorialSubHint.text = "Connect start and finish in this level."
            tutorialSubHint.fontSize = LabelSizing.fittedLabelFontSize(text: tutorialSubHint.text ?? "", fontName: "Optima-Bold", preferredSize: size.height * 0.032, maxWidth: size.width * 0.92)
        } else {
            tutorialHint.text = "Good"
            tutorialHint.fontSize = size.height * 0.044
            tutorialSubHint.text = "Keep going until the path is connected."
            tutorialSubHint.fontSize = LabelSizing.fittedLabelFontSize(text: tutorialSubHint.text ?? "", fontName: "Optima-Bold", preferredSize: size.height * 0.032, maxWidth: size.width * 0.92)
        }
    }

    private func showFinishButton() {
        if finishButton != nil {
            finishButton?.isHidden = false
            return
        }
        let buttonSize = CGSize(width: size.width * 0.62, height: size.height * 0.095)
        finishButton = SpriteButton(texture: ButtonTextureFactory.makeTextButtonTexture(title: "Back to Menu", size: buttonSize, fontName: "Optima-Bold", textColor: fontColor)) {
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
}

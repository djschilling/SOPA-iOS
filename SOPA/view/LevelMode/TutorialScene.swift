import Foundation
import SpriteKit
import UIKit

class TutorialScene: SKScene {
    private var currentPage = 0
    private let headline = SKLabelNode(fontNamed: "Optima-Bold")
    private let textLine1 = SKLabelNode(fontNamed: "Optima-Bold")
    private let textLine2 = SKLabelNode(fontNamed: "Optima-Bold")
    private let textLine3 = SKLabelNode(fontNamed: "Optima-Bold")
    private let tapHint = SKLabelNode(fontNamed: "Optima-Bold")
    private var letsGoButton: SpriteButton?

    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SopaTheme.blackBackground
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
        title.fontColor = SopaTheme.gameText
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.78)
        addChild(title)
    }

    private func addContentNodes() {
        headline.fontColor = SopaTheme.gameText
        headline.fontSize = size.height * 0.048
        headline.position = CGPoint(x: size.width * 0.5, y: size.height * 0.62)
        addChild(headline)

        textLine1.fontColor = SopaTheme.gameText
        textLine1.fontSize = size.height * 0.034
        textLine1.position = CGPoint(x: size.width * 0.5, y: size.height * 0.54)
        addChild(textLine1)

        textLine2.fontColor = SopaTheme.gameText
        textLine2.fontSize = size.height * 0.034
        textLine2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.48)
        addChild(textLine2)

        textLine3.fontColor = SopaTheme.gameText
        textLine3.fontSize = size.height * 0.034
        textLine3.position = CGPoint(x: size.width * 0.5, y: size.height * 0.42)
        addChild(textLine3)

        tapHint.fontColor = SopaTheme.gameText
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
        headline.fontSize = LabelSizing.fittedLabelFontSize(text: headlineText, fontName: "Optima-Bold", preferredSize: size.height * 0.048, maxWidth: size.width * 0.90)

        textLine1.text = line1
        textLine1.fontSize = LabelSizing.fittedLabelFontSize(text: line1, fontName: "Optima-Bold", preferredSize: size.height * 0.034, maxWidth: size.width * 0.92)
        textLine2.text = line2
        textLine2.fontSize = LabelSizing.fittedLabelFontSize(text: line2, fontName: "Optima-Bold", preferredSize: size.height * 0.034, maxWidth: size.width * 0.92)
        textLine3.text = line3
        textLine3.fontSize = LabelSizing.fittedLabelFontSize(text: line3, fontName: "Optima-Bold", preferredSize: size.height * 0.034, maxWidth: size.width * 0.92)
        tapHint.text = hint
        tapHint.fontSize = LabelSizing.fittedLabelFontSize(text: hint, fontName: "Optima-Bold", preferredSize: size.height * 0.030, maxWidth: size.width * 0.92)
    }

    private func ensureLetsGoButton() {
        if letsGoButton != nil {
            return
        }

        let buttonSize = CGSize(width: size.width * 0.34, height: size.height * 0.10)
        let button = SpriteButton(texture: ButtonTextureFactory.makeTextButtonTexture(title: "Let's Go", size: buttonSize, fontName: "Optima-Bold", textColor: SopaTheme.gameText)) {
            ResourcesManager.getInstance().storyService?.loadTutorialGameSceneFromTutorialScene()
        }
        button.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        addChild(button)
        letsGoButton = button
    }
}

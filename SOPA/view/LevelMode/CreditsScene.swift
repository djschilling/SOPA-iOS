import Foundation
import SpriteKit
import UIKit

class CreditsScene: SKScene {
    private let sectionColor = SopaTheme.neonBlue

    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SopaTheme.blackBackground
        addBackButton()
        addTitle()
        addCreditsContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addBackButton() {
        let side = size.height * 0.08
        let backButton = SpriteButton(texture: ButtonTextureFactory.makeCircleButtonTexture(symbolName: "chevron.left", side: side)) {
            ResourcesManager.getInstance().storyService?.loadStartMenuScene()
        }
        backButton.position = CGPoint(x: size.height * 0.057, y: size.height * 0.91)
        addChild(backButton)
    }

    private func addTitle() {
        let title = SKLabelNode(fontNamed: "Impact")
        title.text = "CREDITS"
        title.fontSize = size.height * 0.09
        title.fontColor = SopaTheme.titleGray
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
        line.fontSize = LabelSizing.fittedLabelFontSize(
            text: text,
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
        line.fontSize = LabelSizing.fittedLabelFontSize(
            text: text,
            fontName: "HelveticaNeue",
            preferredSize: size.height * 0.026,
            maxWidth: size.width * 0.90
        )
        line.fontColor = SopaTheme.bodyText
        line.position = CGPoint(x: size.width * 0.09, y: y)
        addChild(line)
    }
}

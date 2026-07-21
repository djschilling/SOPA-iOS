import Foundation
import SpriteKit
import UIKit

class TutorialScene: SKScene {
    private var step = 0
    private var leaveScene = false

    private var firstA: SKSpriteNode!
    private var firstB: SKSpriteNode!
    private var secondA: SKSpriteNode!
    private var secondB: SKSpriteNode!
    private var letsGo: SKSpriteNode!

    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SopaTheme.blackBackground
        addScreens()
        addBackButton()
        showStep()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addScreens() {
        let width = size.width
        // The screens are split into a top (A) and bottom (B) half that tile vertically,
        // mirroring the Android tutorial artwork. Keep each half's aspect ratio.
        let aHeight = width * 910.0 / 1024.0
        let bHeight = width * 960.0 / 1080.0
        let topInset = (size.height - (aHeight + bHeight)) / 2.0
        let aCenterY = size.height - topInset - aHeight / 2.0
        let bCenterY = size.height - topInset - aHeight - bHeight / 2.0

        firstA = makeScreen(imageNamed: "firstTutorialScreenA", width: width, height: aHeight, centerY: aCenterY)
        firstB = makeScreen(imageNamed: "firstTutorialScreenB", width: width, height: bHeight, centerY: bCenterY)
        secondA = makeScreen(imageNamed: "secondTutorialScreenA", width: width, height: aHeight, centerY: aCenterY)
        secondB = makeScreen(imageNamed: "secondTutorialScreenB", width: width, height: bHeight, centerY: bCenterY)

        let letsGoWidth = width * 0.5
        letsGo = SKSpriteNode(imageNamed: "tutorialLetsGo")
        letsGo.size = CGSize(width: letsGoWidth, height: letsGoWidth * 234.0 / 788.0)
        letsGo.position = CGPoint(x: size.width / 2.0, y: size.height * 0.5)
        letsGo.zPosition = 5
        addChild(letsGo)
    }

    private func makeScreen(imageNamed: String, width: CGFloat, height: CGFloat, centerY: CGFloat) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.size = CGSize(width: width, height: height)
        node.position = CGPoint(x: size.width / 2.0, y: centerY)
        addChild(node)
        return node
    }

    private func addBackButton() {
        let side = size.height * 0.08
        let backButton = SpriteButton(texture: ButtonTextureFactory.makeMinimalBackTexture(side: side)) { [weak self] in
            self?.leaveScene = true
            ResourcesManager.getInstance().storyService?.loadStartMenuScene()
        }
        backButton.position = CGPoint(x: size.height * 0.057, y: size.height * 0.95)
        backButton.zPosition = 10
        addChild(backButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard step < 2 else {
            return
        }
        step += 1
        showStep()
    }

    private func showStep() {
        let onFirst = step == 0
        let onSecond = step == 1
        firstA.isHidden = !onFirst
        firstB.isHidden = !onFirst
        secondA.isHidden = !onSecond
        secondB.isHidden = !onSecond
        letsGo.isHidden = step < 2

        if step >= 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self, !self.leaveScene else {
                    return
                }
                ResourcesManager.getInstance().storyService?.loadTutorialGameSceneFromTutorialScene()
            }
        }
    }
}

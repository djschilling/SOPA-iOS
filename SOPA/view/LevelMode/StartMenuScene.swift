import Foundation
import SpriteKit
import UIKit

class StartMenuScene: SKScene {
    private let twitterUrl = "https://twitter.com/sopagame"
    private let shareText = "I played SOPA: https://play.google.com/store/apps/details?id=com.sopaapp"

    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SopaTheme.blackBackground
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
        title.fontColor = SopaTheme.titleGray
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.77)
        addChild(title)
    }

    private func addButtons() {
        let menuItems: [(title: String, action: () -> Void)] = [
            ("LEVEL MODE", { ResourcesManager.getInstance().storyService?.loadLevelCoiceScene() }),
            ("JUST PLAY", { ResourcesManager.getInstance().storyService?.loadJustPlaySceneFromMenuScene() }),
            ("TUTORIAL", { ResourcesManager.getInstance().storyService?.loadTutorialSceneFromMenuScene() }),
            ("CREDITS", { ResourcesManager.getInstance().storyService?.loadCreditsSceneFromMenuScene() })
        ]

        let buttonSize = CGSize(width: size.width * 0.76, height: size.height * 0.095)
        let firstY = size.height * 0.62
        let verticalGap = size.height * 0.11

        for (index, item) in menuItems.enumerated() {
            let button = SpriteButton(texture: ButtonTextureFactory.makeNeonTextTexture(title: item.title, size: buttonSize), onClick: item.action)
            button.position = CGPoint(x: size.width / 2.0, y: firstY - CGFloat(index) * verticalGap)
            addChild(button)
        }
    }

    private func addSocialButtons() {
        let buttonSide = min(size.width * 0.18, size.height * 0.10)

        let shareButton = SpriteButton(
            texture: ButtonTextureFactory.makeSocialButtonTexture(symbolName: "point.3.connected.trianglepath.dotted", size: CGSize(width: buttonSide, height: buttonSide), fillBackground: true),
            onClick: shareApp
        )
        shareButton.position = CGPoint(x: size.width * 0.20, y: size.height * 0.14)
        addChild(shareButton)

        let twitterButton = SpriteButton(
            texture: ButtonTextureFactory.makeSocialButtonTexture(symbolName: "paperplane.fill", size: CGSize(width: buttonSide * 1.15, height: buttonSide * 1.15), fillBackground: false),
            onClick: openTwitter
        )
        twitterButton.position = CGPoint(x: size.width * 0.74, y: size.height * 0.14)
        addChild(twitterButton)
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

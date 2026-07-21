import SpriteKit
import UIKit

enum LabelSizing {
    static func fittedLabelFontSize(
        text: String,
        fontName: String,
        preferredSize: CGFloat,
        maxWidth: CGFloat,
        minSize: CGFloat = 10.0
    ) -> CGFloat {
        guard !text.isEmpty else {
            return preferredSize
        }

        let label = SKLabelNode(fontNamed: fontName)
        label.text = text
        var currentSize = preferredSize
        label.fontSize = currentSize

        while label.frame.width > maxWidth && currentSize > minSize {
            currentSize -= 1.0
            label.fontSize = currentSize
        }
        return currentSize
    }

    static func fittedTextFontSize(
        text: String,
        fontName: String,
        preferredSize: CGFloat,
        weight: UIFont.Weight,
        maxWidth: CGFloat,
        minSize: CGFloat = 10.0
    ) -> CGFloat {
        var currentSize = preferredSize
        while currentSize > minSize {
            let font = UIFont(name: fontName, size: currentSize) ?? UIFont.systemFont(ofSize: currentSize, weight: weight)
            let measuredWidth = (text as NSString).size(withAttributes: [.font: font]).width
            if measuredWidth <= maxWidth {
                return currentSize
            }
            currentSize -= 1.0
        }
        return minSize
    }
}

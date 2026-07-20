import SpriteKit
import UIKit

enum ButtonTextureFactory {
    static func makeCircleButtonTexture(
        symbolName: String,
        side: CGFloat,
        circleColor: UIColor = SopaTheme.circleButtonFill,
        iconColor: UIColor = SopaTheme.circleButtonIcon,
        symbolScale: CGFloat = 0.42,
        symbolWeight: UIImage.SymbolWeight = .semibold
    ) -> SKTexture {
        let textureSize = CGSize(width: side, height: side)
        let renderer = UIGraphicsImageRenderer(size: textureSize)
        let image = renderer.image { _ in
            circleColor.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: textureSize)).fill()

            let config = UIImage.SymbolConfiguration(pointSize: side * symbolScale, weight: symbolWeight)
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

    static func makeMinimalBackTexture(side: CGFloat) -> SKTexture {
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

    static func makePageArrowTexture(imageNamed: String, side: CGFloat) -> SKTexture {
        let texture = SKTexture(imageNamed: imageNamed)
        let imageSize = texture.size()
        let ratio = imageSize.width / max(1, imageSize.height)
        let targetSize = CGSize(width: side * ratio, height: side)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { _ in
            UIImage(named: imageNamed)?.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return SKTexture(image: image)
    }

    static func makeNeonTextTexture(title: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let glowShadow = NSShadow()
            glowShadow.shadowColor = SopaTheme.neonGlowBlue
            glowShadow.shadowBlurRadius = size.height * 0.22
            glowShadow.shadowOffset = .zero

            let font = UIFont(name: "HelveticaNeue-Light", size: size.height * 0.60)
                ?? UIFont.systemFont(ofSize: size.height * 0.60, weight: .light)
            let textRect = CGRect(x: 0, y: size.height * 0.22, width: size.width, height: size.height * 0.60)

            let glowAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: SopaTheme.neonBlue,
                .strokeColor: SopaTheme.neonBlue,
                .strokeWidth: -1.2,
                .paragraphStyle: paragraphStyle,
                .shadow: glowShadow
            ]
            title.draw(in: textRect, withAttributes: glowAttributes)

            let coreAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: SopaTheme.neonCoreBlue,
                .paragraphStyle: paragraphStyle
            ]
            title.draw(in: textRect, withAttributes: coreAttributes)
        }
        return SKTexture(image: image)
    }

    static func makeSocialButtonTexture(symbolName: String, size: CGSize, fillBackground: Bool) -> SKTexture {
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

    static func makeCircleTextButtonTexture(
        title: String,
        side: CGFloat,
        circleColor: UIColor = SopaTheme.circleButtonFill,
        textColor: UIColor = SopaTheme.circleButtonIcon
    ) -> SKTexture {
        let textureSize = CGSize(width: side, height: side)
        let renderer = UIGraphicsImageRenderer(size: textureSize)
        let image = renderer.image { _ in
            circleColor.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: textureSize)).fill()

            let lines = title.split(separator: "\n").map(String.init)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let fontSize = side * 0.20
            let font = UIFont(name: "Impact", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            let lineHeight = fontSize * 1.05
            let totalHeight = lineHeight * CGFloat(lines.count)
            var y = (side - totalHeight) / 2.0
            for line in lines {
                line.draw(in: CGRect(x: 0, y: y, width: side, height: lineHeight), withAttributes: attributes)
                y += lineHeight
            }
        }
        return SKTexture(image: image)
    }

    static func makeTextButtonTexture(
        title: String,
        size: CGSize,
        fontName: String,
        textColor: UIColor,
        weight: UIFont.Weight = .semibold
    ) -> SKTexture {
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
            let buttonFontSize = LabelSizing.fittedTextFontSize(
                text: title,
                fontName: fontName,
                preferredSize: size.height * 0.38,
                weight: weight,
                maxWidth: size.width * 0.90
            )
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: fontName, size: buttonFontSize) ?? UIFont.systemFont(ofSize: buttonFontSize, weight: weight),
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            let textRect = CGRect(x: 0.0, y: size.height * 0.30, width: size.width, height: size.height * 0.5)
            title.draw(in: textRect, withAttributes: attributes)
        }
        return SKTexture(image: image)
    }
}

func makeCircleButtonTexture(symbolName: String, side: CGFloat) -> SKTexture {
    ButtonTextureFactory.makeCircleButtonTexture(symbolName: symbolName, side: side)
}

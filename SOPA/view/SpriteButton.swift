//
//  RestartButton.swift
//  SOPA
//
//  Created by Raphael Schilling on 18.04.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit
class SpriteButton: SKSpriteNode {
    var onClick : () -> Void
    init(imageNamed: String, onClick: @escaping () -> Void) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.onClick = onClick
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        isUserInteractionEnabled = true
    }
    
    init(texture: SKTexture, onClick: @escaping () -> Void) {
        self.onClick = onClick
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onClick()
    }
}

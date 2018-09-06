//
//  EffctSpriteButton.swift
//  SOPA
//
//  Created by Raphael Schilling on 06.09.18.
//  Copyright © 2018 David Schilling. All rights reserved.
//

import Foundation
import SpriteKit
class EffectSpriteButton: SKEffectNode {
    let button: SpriteButton
    init(imageNamed: String, onClick: @escaping () -> Void, size: CGSize) {
        button = SpriteButton(imageNamed: imageNamed, onClick: onClick)
        button.size.height = size.height
        button.size.width = size.width
        super.init()
        addChild(button)
        
        filter = CIFilter(name: "CIColorControls")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEnabled(_ enabled: Bool) {
        button.isUserInteractionEnabled = enabled
        if enabled {
            filter?.setValue(1.0, forKey: kCIInputSaturationKey)
        } else {
            filter?.setValue(0.0, forKey: kCIInputSaturationKey)
        }
    }
}

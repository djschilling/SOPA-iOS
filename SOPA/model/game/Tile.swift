//
//  Tile.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

struct Tile : Hashable {

    var top: Bool
    var bottom: Bool
    var left: Bool
    var right: Bool
    var tileType: TileType
    var shortcut: Character

    init(top: Bool, bottom: Bool, left: Bool, right: Bool, tileType: TileType, shortcut: Character) {
        self.top = top;
        self.bottom = bottom;
        self.left = left;
        self.right = right;
        self.tileType = tileType
        self.shortcut = shortcut
    }
    
    init() {
        tileType = TileType.NONE
        shortcut = "n"
        bottom = false
        top = false
        left = false
        right = false
    }

    var hashValue: Int {
        return top.hashValue ^ bottom.hashValue ^ left.hashValue ^ right.hashValue ^ tileType.hashValue ^ shortcut.hashValue
    }

    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.top == rhs.top && lhs.bottom == rhs.bottom && lhs.left == rhs.left && lhs.right == rhs.right && lhs.tileType == rhs.tileType && lhs.shortcut == rhs.shortcut
    }
}

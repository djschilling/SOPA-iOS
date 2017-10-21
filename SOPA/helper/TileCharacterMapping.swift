//
//  TileCharacterMapping.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

let TILE_CHARACTER_MAP = [
    Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.NONE, shortcut: "n"): "n",
    Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "o",
    Tile(top: true, bottom: false, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "t"): "t",
    Tile(top: false, bottom: true, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "b"): "b",
    Tile(top: false, bottom: false, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "r"): "r",
    Tile(top: false, bottom: false, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "l"): "l",
    Tile(top: false, bottom: false, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "a"): "a",
    Tile(top: false, bottom: true, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "u"): "u",
    Tile(top: false, bottom: true, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "c"): "c",
    Tile(top: false, bottom: true, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "d"): "d",
    Tile(top: true, bottom: false, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "e"): "e",
    Tile(top: true, bottom: false, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "g"): "g",
    Tile(top: true, bottom: false, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "h"): "h",
    Tile(top: true, bottom: true, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "i"): "i",
    Tile(top: true, bottom: true, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "j"): "j",
    Tile(top: true, bottom: true, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "k"): "k",
    Tile(top: true, bottom: true, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "m"): "m",
]

let CHARACTER_TILE_MAP = [
    "s": Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.START, shortcut: "s"),
    "f": Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.FINISH, shortcut: "f"),
    "n": Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.NONE, shortcut: "n"),
    "o": Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "o"),
    "t": Tile(top: true, bottom: false, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "t"),
    "b": Tile(top: false, bottom: true, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "b"),
    "r": Tile(top: false, bottom: false, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "r"),
    "l": Tile(top: false, bottom: false, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "l"),
    "a": Tile(top: false, bottom: false, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "a"),
    "u": Tile(top: false, bottom: true, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "u"),
    "c": Tile(top: false, bottom: true, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "c"),
    "d": Tile(top: false, bottom: true, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "d"),
    "e": Tile(top: true, bottom: false, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "e"),
    "g": Tile(top: true, bottom: false, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "g"),
    "h": Tile(top: true, bottom: false, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "h"),
    "i": Tile(top: true, bottom: true, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "i"),
    "j": Tile(top: true, bottom: true, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "j"),
    "k": Tile(top: true, bottom: true, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "k"),
    "m": Tile(top: true, bottom: true, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "m"),
]

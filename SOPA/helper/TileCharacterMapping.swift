//
//  TileCharacterMapping.swift
//  SOPA
//
//  Created by David Schilling on 21.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

let TILE_CHARACTER_MAP = [
    Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.NONE, shortcut: "o"): "n",
    Tile(top: false, bottom: false, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "o",
    Tile(top: true, bottom: false, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "t",
    Tile(top: false, bottom: true, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "b",
    Tile(top: false, bottom: false, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "r",
    Tile(top: false, bottom: false, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "l",
    Tile(top: false, bottom: false, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "a",
    Tile(top: false, bottom: true, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "u",
    Tile(top: false, bottom: true, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "c",
    Tile(top: false, bottom: true, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "d",
    Tile(top: true, bottom: false, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "e",
    Tile(top: true, bottom: false, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "g",
    Tile(top: true, bottom: false, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "h",
    Tile(top: true, bottom: true, left: false, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "i",
    Tile(top: true, bottom: true, left: false, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "j",
    Tile(top: true, bottom: true, left: true, right: false, tileType: TileType.PUZZLE, shortcut: "o"): "k",
    Tile(top: true, bottom: true, left: true, right: true, tileType: TileType.PUZZLE, shortcut: "o"): "m",
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

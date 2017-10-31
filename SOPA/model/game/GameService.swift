//
//  GameService.swift
//  SOPA
//
//  Created by David Schilling on 31.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

protocol GameService {

    func solvedPuzzle() -> Bool

    func shiftLine(horizontal: Bool, row: Int, steps: Int, silent: Bool)

    func getLevel() -> Level

    func attach(observer: GameSceneObserver)

    func detatch(observer: GameSceneObserver)

    func notifyAllObserver()
}

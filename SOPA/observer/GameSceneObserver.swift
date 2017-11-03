//
//  GameSceneObserver.swift
//  SOPA
//
//  Created by David Schilling on 31.10.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation

protocol GameSceneObserver {

    var id : Int{ get }

    func updateGameScene()
}

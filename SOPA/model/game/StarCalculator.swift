//
//  StarCalculator.swift
//  SOPA
//
//  Created by Raphael Schilling on 08.11.17.
//  Copyright © 2017 David Schilling. All rights reserved.
//

import Foundation
class StarCalculator {
    
    public func getStars(neededMoves: Int, minimumMoves: Int) -> Int {
        var stars: Int;
    
        if ((minimumMoves - neededMoves) >= 0) {
            stars = 3;
        } else if ((Float(minimumMoves) / Float(neededMoves)) > 0.6) {
            stars = 2;
        } else {
            stars = 1;
        }
        return stars;
    }
}

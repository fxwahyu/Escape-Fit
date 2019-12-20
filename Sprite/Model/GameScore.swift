//
//  GameScore.swift
//  Sprite
//
//  Created by Wahyu Herdianto on 28/10/19.
//  Copyright © 2019 Felix Kylie. All rights reserved.
//

import Foundation

class GameScore{
    static let shared = MusicPlayer()
    
    var winnerGame1: String = ""
    var winnerGame2: String = ""
    
    var scorePlayer1: Int = 0
    var scorePlayer2: Int = 0
    
    func addScore(player: String){
        if player == "player1"{
            scorePlayer1 += 1
        } else if player == "player2"{
            scorePlayer2 += 1
        }
    }
}



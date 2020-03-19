//
//  MoveCommand.swift
//  XO-game
//
//  Created by Григорий Мартюшин on 19.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class MoveCommand {
    var position: GameboardPosition
    var player: Player
    var gBoardView: GameboardView
    var gameboard: Gameboard
    
    init(at position: GameboardPosition, from player: Player, gBoardView: GameboardView, gameboard: Gameboard) {
        self.position = position
        self.gBoardView = gBoardView
        self.player = player
        self.gameboard = gameboard
    }
}

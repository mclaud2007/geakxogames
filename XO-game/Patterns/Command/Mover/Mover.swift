//
//  Mover.swift
//  XO-game
//
//  Created by Григорий Мартюшин on 19.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class Mover {
    public func makeMove(at position: GameboardPosition, from player: Player, gBoardView: GameboardView, gameboard: Gameboard) {
        let markView = player.markViewPrototype.makeCopy()
        
        gameboard.setPlayer(player, at: position)
        
        // Если мы не можем поставить маркер, значит там уже есть еще какой-то
        // по правилам мы его должны заменить
        if !gBoardView.canPlaceMarkView(at: position) {
            gBoardView.removeMarkView(at: position)
        }
        
        // Тсавим маркер
        gBoardView.placeMarkView(markView, at: position)
        
        LogAction.log(.playerInput(player: player, position: position))
    }
}

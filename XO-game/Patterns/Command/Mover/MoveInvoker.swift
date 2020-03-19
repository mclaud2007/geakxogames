//
//  MoveInvoker.swift
//  XO-game
//
//  Created by Григорий Мартюшин on 19.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class MoveInvoker {
    static let shared = MoveInvoker()
    var commands: [MoveCommand] = []
    var mover = Mover()
    
    func addMove(at position: GameboardPosition, from player: Player, gBoardView: GameboardView, gameboard: Gameboard) {
        commands.append(MoveCommand(at: position, from: player, gBoardView: gBoardView, gameboard: gameboard))
    }
    
    func perform(){
        if commands.count > 0 {
            // Нам нужно вызывать команды по очереди - сначала первый игрок, потом второй
            // Т.к. у нас идут все команды одна за одной, то поделим массив по полам
            // первая его часть будет ход первого игрока, текущий ход * 2 - второго
            let halfArray = commands.count/2
            
            for i in 0..<halfArray {
                if commands.indices.contains(i) {
                    // Первый игрок
                    let firstPlayerCommand = commands[i]
                    self.mover.makeMove(at: firstPlayerCommand.position, from: firstPlayerCommand.player, gBoardView: firstPlayerCommand.gBoardView, gameboard: firstPlayerCommand.gameboard)
                    
                    // Второй игрок
                    let secondPlayerCommand = commands[(i + halfArray)]
                    self.mover.makeMove(at: secondPlayerCommand.position, from: secondPlayerCommand.player, gBoardView: secondPlayerCommand.gBoardView, gameboard: secondPlayerCommand.gameboard)
                }
            }
        }
    }
    
    func reset() {
        commands.removeAll()
    }
}

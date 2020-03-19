//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Григорий Мартюшин on 18.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class ComputerInputState: PlayerInputState {
    override init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, markViewPrototype: MarkView) {
        // Инициализируем родителя
        super.init(player: player, gameViewController: gameViewController, gameboard: gameboard, gameboardView: gameboardView, markViewPrototype: markViewPrototype)
        
        // Если это второй игрок, то ставим отметку сразу
        if player == .second {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.makeMove()
            })
        }
    }
    
    private func findPosition() -> GameboardPosition? {
        if let gBoard = self.gameboardView {
            for row in 0..<GameboardSize.rows {
                for column in 0..<GameboardSize.columns {
                    let currentPosition = GameboardPosition(column: column, row: row)
                    
                    // Ищем заполненную ячейку, но не свою
                    if (!gBoard.canPlaceMarkView(at: currentPosition) && !gBoard.isUserMark(at: currentPosition, by: self.player)) {
                        // пытаемся воткнуть куда-то рядом свою отметку
                        let posibleSteps = [[column - 1, row], [column + 1, row],
                                            [column, row + 1], [column, row - 1],
                                            [column - 1, row - 1], [column - 1, row + 1],
                                            [column + 1, row - 1], [column + 1, row + 1],
                                            [column, row]
                        ]
                
                        for position in posibleSteps {
                            // Допустим ли такая цифра в качестве колонки
                            if (position[0] >= 0 && position[0] < GameboardSize.columns) {
                                // Допустима ли такая цифра в качестве строки
                                if (position[1] >= 0 && position[1] < GameboardSize.rows) {
                                    // Можно ли сюда поставить отметку
                                    let posiblePosition = GameboardPosition(column: position[0], row: position[1])
                                    
                                    if gBoard.canPlaceMarkView(at: posiblePosition) {
                                        return posiblePosition
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    private func makeMove() {
        if let markPosition = self.findPosition() {
            gameboardView?.performMove(at: markPosition)
        }
        // Не смогли найти позицию куда можно поставить ход - просто пропустим его
        else {
            LogAction.log(.playerNotFoundMove(player: self.player))
            gameboardView?.performMove(at: nil)
        }
    }
}

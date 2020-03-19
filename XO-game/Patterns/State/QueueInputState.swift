//
//  PlayerInputState.swift
//  XO-game
//
//  Created by Elena Gracheva on 09/11/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

public class QueueInputState: GameState {
    
    public private(set) var isCompleted = false
    
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    public let markViewPrototype: MarkView
    private let moveInvoker = MoveInvoker.shared
    
    // Количество уже проставленных шагов
    private var moveCount = 0
    
    // Количество шагов которые можно поставить за этап
    private var moveCountMax = 5
    
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, markViewPrototype: MarkView, maxMovePerPlayer: Int) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
        self.isCompleted = false
        self.moveCountMax = maxMovePerPlayer
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    public func complete() {
        self.isCompleted = true
    }
    
    public func addMark(at position: GameboardPosition) {
        if let gameboardView = self.gameboardView,
            let gameboard = self.gameboard
        {
            moveInvoker.addMove(at: position, from: self.player, gBoardView: gameboardView, gameboard: gameboard)
            moveCount += 1
            
            //  количество шагов достигло максимума
            if moveCount == moveCountMax {
                self.complete()
            }
        }
    }
    
    
    public func getNextPlayer() -> Player? {
        player.next
    }
    
    public func getPlayer() -> Player {
        player
    }
}

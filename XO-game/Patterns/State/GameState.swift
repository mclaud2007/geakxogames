//
//  GameState.swift
//  XO-game
//
//  Created by Elena Gracheva on 05.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public protocol GameState {
    
    var isCompleted: Bool { get }
    
    func begin()
    
    func complete()
    
    func addMark(at position: GameboardPosition)
    
    func getNextPlayer() -> Player?
    
    func getPlayer() -> Player
}

//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet weak var gameModeLabel: UILabel!
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    
    // Если что-то пойдет не так по-умолчанию режим игры pvp
    public var gameMode: GameMode = .pvp
    
    private let gameboard = Gameboard()
    
    // Максимальное число ходов на игрока в режиме по очереди
    let maxMovePerPlayerQue = 5
    
    private var currentState: GameState! {
        didSet {
            if let currentState = self.currentState {
                currentState.begin()
            }
        }
    }
    
    private let moveInvoker = MoveInvoker.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        
        // Навигационная строка не нужна, будем возвращать в главное меню кнопкой
        navigationController?.navigationBar.isHidden = true
        
        // Выставляем название текущего режима
        switch gameMode {
        case .pvc:
            gameModeLabel.text = "PvC"
        case .que:
            gameModeLabel.text = "Queue"
        default:
            gameModeLabel.text = "PvP"
        }
        
        // Обрабатываем нажатие на поле
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            // Если режим que и количество команд равно 6, выполним их всех
            if let position = position {
                let maxCommandToPerform = ((self.maxMovePerPlayerQue * 2) - 1)
                
                if (self.gameMode == .que && self.moveInvoker.commands.count == maxCommandToPerform)  {
                    self.currentState.addMark(at: position)
                    self.moveInvoker.perform()
                }
            } else {
                // Закончим ход
                self.currentState.complete()
            }
            
            if let winner = self.referee.determineWinner() {
                self.currentState = GameEndedState(winner: winner, gameViewController: self)
                return
            } 
            
            if let position = position {
                self.currentState.addMark(at: position)
            }
            
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    @IBAction func goToMainMenu(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Данная функция просто логическая, т.е. она запускается только один раз
    // в первый, когда currentState - nil, т.е. игра только началась
    private func goToFirstState() {
        // Текущий стейт должен быть пустым
        currentState = nil
        goToNextState()
    }

    private func goToNextState() {
        var player: Player
        
        if let currentState = self.currentState,
            let nextPlayer = currentState.getNextPlayer()
        {
            player = nextPlayer
        } else {
            player = .first
        }
        
        // В зависимости от выбранного режима стартуем тот или иной стэйт
        if gameMode == .pvp {
            self.currentState = PlayerInputState(player: player,
                                                 gameViewController: self,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView,
                                                 markViewPrototype: player.markViewPrototype)
        } else if gameMode == .que {
            self.currentState = QueueInputState(player: player,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView,
                                                markViewPrototype: player.markViewPrototype, maxMovePerPlayer: maxMovePerPlayerQue)
            
        } else {
            self.currentState = ComputerInputState(player: player,
                                                   gameViewController: self,
                                                   gameboard: gameboard,
                                                   gameboardView: gameboardView,
                                                   markViewPrototype: player.markViewPrototype)
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        gameboardView.clear()
        gameboard.clear()
        moveInvoker.reset()
        goToFirstState()
        
        LogAction.log(.restartGame)
    }
}


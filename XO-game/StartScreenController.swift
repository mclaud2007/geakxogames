//
//  StatScreenController.swift
//  XO-game
//
//  Created by Григорий Мартюшин on 18.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

class StartScreenController: UIViewController {

    @IBOutlet weak var gameModeChanger: UISegmentedControl!
    
    // По-умолчанию режим игрок против игрока
    private var currentGameMode: GameMode = .pvp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModeChanger.selectedSegmentIndex = 0
    }
    
    @IBAction func gameModeChange(_ sender: Any) {
        switch gameModeChanger.selectedSegmentIndex {
        case 1:
            currentGameMode = .pvc
        case 2:
            currentGameMode = .que
        default:
            currentGameMode = .pvp
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController,
            let id = segue.identifier,
            id == "startGame"
        {
            destination.gameMode = currentGameMode
        }
    }

}

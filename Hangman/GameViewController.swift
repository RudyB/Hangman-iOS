//
//  ViewController.swift
//  Hangman
//
//  Created by Rudy Bermudez on 5/31/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
	
	// MARK: - Class Variables
	var game:Game?

	// MARK: - IB Outlets/Actions
    @IBOutlet weak var incorrectGuessesTitle: UILabel!
	@IBOutlet weak var incorrectGuessesLabel: UILabel!
	@IBOutlet weak var guessesRemainingTitle: UILabel!
    @IBOutlet weak var guessesRemainingLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
	@IBOutlet weak var hintLabel: UILabel!
	@IBOutlet weak var hintButton: UIButton!
    
    @IBAction func guessTextFieldAction() {
        play(guess: guessTextField.text)
    }
	
	@IBAction func hintButtonAction() {
		hintLabel.isHidden = false;
		Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.hideHint), userInfo: nil, repeats: false)
	}

	func hideHint(){
		hintLabel.isHidden = true
	}

	// MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		initializeView()
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true;
    }
	
	// MARK: - Class Methods
	
	func initializeView() {
		hintLabel.isHidden = true
		currentStatusLabel.text = "Loading Word"
		incorrectGuessesLabel.text = ""
		guessesRemainingLabel.text = ""
		guessTextField.isEnabled = false
		guessesRemainingTitle.isHidden = true
		updateDisplay()
	}
	
    func updateDisplay() -> () {
        if let game = game {
			guessTextField.isEnabled = true
			guessesRemainingTitle.isHidden = false
            if game.getMisses() != "" {
                incorrectGuessesTitle.isHidden = false;
            }
            incorrectGuessesLabel.text = game.getMisses();
            currentStatusLabel.text = game.getCurrentProgress();
            guessTextField.text = "";
			guessesRemainingLabel.text = "\(game.getRemainingTries())"
        }
        
    }
    
	func startNewGame(_ sender: UIAlertAction) {
        navigationController?.popToRootViewController(animated: true)
    }
	
	func getDictionaryDefinition() {
		if let game = game {
			if game.difficulty != .Hard {
				
				WordAPI.getDictionaryDefinition(wordToSearch: game.answer, completionHandler: { (definition, error) in
					if error == nil {
						DispatchQueue.main.async {
							if let definition = definition {
								self.hintLabel.text = definition
								self.hintButton.isHidden = false
							} else {
								DispatchQueue.main.async {
									self.hintButton.isHidden = true
								}
							}
						}
					} else {
						DispatchQueue.main.async {
							self.hintButton.isHidden = true
						}
					}
				})
			}
		}
	}

    func play(guess: String?){
        if let game = game {
            if game.getRemainingTries() > 0 && !game.isSolved() {
				do {
					try game.applyGuess(guess: guess)
				} catch Game.GameError.letterAlreadyGuessed(let letter) {
					Game.showAlert(targetClass: self, title: "The letter '\(letter)' has already been guessed")
				
				} catch Game.GameError.characterIsNotLetter {
					Game.showAlert(targetClass: self, title: "The guess must be a letter")
				
				} catch {
					Game.showAlert(targetClass: self, title: "An unexpected error has occured")
					self.navigationController?.popToRootViewController(animated: true)
				}
                updateDisplay();
            }
            let newGameAction = UIAlertAction(title: "New Game", style: .default, handler: startNewGame)
			
            if !game.isSolved() && game.getRemainingTries() <= 0 {
				guessTextField.resignFirstResponder()
				Game.showAlert(targetClass: self, title: "Sorry", message: "The word was " + game.getAnswer(), actionList: [newGameAction])
				
            }
            if game.isSolved(){
				guessTextField.resignFirstResponder()
				Game.showAlert(targetClass: self,title: "Congradulations!", message: "You won with " + String(game.getRemainingTries()) + " tries remaining.", actionList: [newGameAction])
            }
        }
    }
	
	
	
}


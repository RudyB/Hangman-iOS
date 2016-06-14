//
//  ViewController.swift
//  Hangman
//
//  Created by Rudy Bermudez on 5/31/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
	
	var game:Game?

    @IBOutlet weak var incorrectGuessesTitle: UILabel!
    @IBOutlet weak var guessesRemainingLabel: UILabel!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    
    @IBAction func guessTextFieldAction() {
        play(guessTextField.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay();
        if let game = game {
            view.makeToast(message: "Guesses Remaining: " + String(game.getRemainingTries()), duration: HRToastDefaultDuration, position: HRToastPositionTop);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func updateDisplay() -> () {
        if let game = game {
            if game.getMisses() != "" {
                incorrectGuessesTitle.hidden = false;
            }
            incorrectGuessesLabel.text = game.getMisses();
            currentStatusLabel.text = game.getCurrentProgress();
            guessTextField.text = "";
        }
        
    }
    
	func startNewGame(sender: UIAlertAction) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    func play(guess: String?){
        if let game = game {
            if game.getRemainingTries() > 0 && !game.isSolved() {
				do {
					if let hit = try game.applyGuess(guess){
						if !hit {
							view.makeToast(message: "Guesses Remaining: " + String(game.getRemainingTries()), duration: HRToastDefaultDuration, position: HRToastPositionTop)
							}
					}
				} catch Game.GameError.LetterAlreadyGuessed(let letter) {
					showAlert(title: "The letter '\(letter)' has already been guessed")
				
				} catch Game.GameError.CharacterIsNotLetter {
					showAlert(title: "The guess must be a letter")
				
				} catch let error {
					fatalError("\(error)")
				}
                updateDisplay();
            }
            let newGameAction = UIAlertAction(title: "New Game", style: .Default, handler: startNewGame)
			
            if !game.isSolved() && game.getRemainingTries() <= 0 {
				guessTextField.resignFirstResponder()
				showAlert(title: "Sorry", message: "The word was " + game.getAnswer(), action: newGameAction)
				
            }
            if game.isSolved(){
				guessTextField.resignFirstResponder()
				showAlert(title: "Congradulations!", message: "You won with " + String(game.getRemainingTries()) + " tries remaining.", action: newGameAction)
            }
        }
    }
	
	func showAlert(title title: String, message: String? = nil, style: UIAlertControllerStyle = .Alert, action:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil) ) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		alert.addAction(action)
		presentViewController(alert, animated: true, completion: nil)
	}
	
}


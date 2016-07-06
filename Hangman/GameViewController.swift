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
        play(guessTextField.text)
    }
	
	@IBAction func hintButtonAction() {
		hintLabel.hidden = false;
		NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(self.hideHint), userInfo: nil, repeats: false)
	}

	func hideHint(){
		hintLabel.hidden = true
	}

	// MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		initializeView()
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
	
	// MARK: - Class Methods
	
	func initializeView() {
		hintLabel.hidden = true
		currentStatusLabel.text = "Loading Word"
		incorrectGuessesLabel.text = ""
		guessesRemainingLabel.text = ""
		guessTextField.enabled = false
		guessesRemainingTitle.hidden = true
		updateDisplay()
	}
	
    func updateDisplay() -> () {
        if let game = game {
			guessTextField.enabled = true
			guessesRemainingTitle.hidden = false
            if game.getMisses() != "" {
                incorrectGuessesTitle.hidden = false;
            }
            incorrectGuessesLabel.text = game.getMisses();
            currentStatusLabel.text = game.getCurrentProgress();
            guessTextField.text = "";
			guessesRemainingLabel.text = "\(game.getRemainingTries())"
        }
        
    }
    
	func startNewGame(sender: UIAlertAction) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
	
	func getDictionaryDefinition() {
		if let game = game {
			WordAPI.getDictionaryDefinition(wordToSearch: game.answer, completionHandler: {
				definition in
				dispatch_async(dispatch_get_main_queue()) {
					self.hintLabel.text = definition
				}
			})
		}
	}
	
    func play(guess: String?){
        if let game = game {
            if game.getRemainingTries() > 0 && !game.isSolved() {
				do {
					try game.applyGuess(guess)
				} catch Game.GameError.LetterAlreadyGuessed(let letter) {
					Game.showAlert(targetClass: self, title: "The letter '\(letter)' has already been guessed")
				
				} catch Game.GameError.CharacterIsNotLetter {
					Game.showAlert(targetClass: self, title: "The guess must be a letter")
				
				} catch {
					Game.showAlert(targetClass: self, title: "An unexpected error has occured")
					self.navigationController?.popToRootViewControllerAnimated(true)
				}
                updateDisplay();
            }
            let newGameAction = UIAlertAction(title: "New Game", style: .Default, handler: startNewGame)
			
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


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
        // Do any additional setup after loading the view, typically from a nib.
        updateDisplay();
        if let game = game {
            view.makeToast(message: "Guesses Remaining: " + String(game.getRemainingTries()), duration: HRToastDefaultDuration, position: HRToastPositionTop);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func updateDisplay() -> () {
        if let game = self.game {
            //guessesRemainingLabel.text = String(game.getRemainingTries())
            if game.getMisses() != "" {
                incorrectGuessesTitle.hidden = false;
            }
            incorrectGuessesLabel.text = game.getMisses();
            currentStatusLabel.text = game.getCurrentProgress();
            guessTextField.text = "";
        }
        
    }
    
    func startNewGame() {
        if let startPage:StartPageViewController = storyboard?.instantiateViewControllerWithIdentifier("startPage") as? StartPageViewController {
            presentViewController(startPage, animated: true, completion: nil)
        }
    }
    

    

    func play(guess: String?){
        if let game = game {
            if game.getRemainingTries() > 0 && !game.isSolved() {
                if let hit = game.applyGuess(guess){
                    if !hit {
                        view.makeToast(message: "Guesses Remaining: " + String(game.getRemainingTries()), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                    }
                }
                updateDisplay();
            }
            
            if !game.isSolved() && game.getRemainingTries() <= 0 {
                let alert = UIAlertController(title: "Sorry!", message: "The word was " + game.getAnswer(), preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "New Game", style: .Default, handler: { (alert: UIAlertAction!) in
                    self.startNewGame()
                }));
                showViewController(alert, sender: self)

            }
            if game.isSolved(){
                let alert = UIAlertController(title: "Congradulations!", message: "You won with " + String(game.getRemainingTries()) + " tries remaining.", preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "New Game", style: .Default, handler: { (alert: UIAlertAction!) in
                    self.startNewGame()
                }));
                showViewController(alert, sender: self)
            }
            
        }
        
    }

}


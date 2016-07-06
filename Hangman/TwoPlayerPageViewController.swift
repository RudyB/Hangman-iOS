//
//  StartPageViewController.swift
//  Hangman
//
//  Created by Rudy Bermudez on 5/31/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import UIKit

class TwoPlayerPageViewController: UIViewController, UITextFieldDelegate{
	
	// MARK: - IB Outlets/Actions
    @IBOutlet weak var answerTextField: UITextField!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBAction func resignKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
	// MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.hidden = true;
		difficultyControl.hidden = true;
        self.answerTextField.delegate = self;
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func prefersStatusBarHidden() -> Bool {
		return true;
	}
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "launchTwoPlayerGameSegue" {
            
            if let destination = segue.destinationViewController as? GameViewController, let answer = answerTextField.text {
                if answer != "" {
					do {
						guard let difficultyControlSegmentTitle = difficultyControl.titleForSegmentAtIndex(difficultyControl.selectedSegmentIndex),
							let difficulty = Game.Difficulty(rawValue: difficultyControlSegmentTitle) else {
							fatalError()
						}
						destination.game = try Game(answer: answer, difficulty: difficulty)
						answerTextField.text = ""
						startButton.hidden = true
						difficultyControl.hidden = true
					} catch Game.GameError.NotAValidWord {
						Game.showAlert(targetClass: self, title: "Not a valid word. Try again")
					} catch Game.GameError.WordNotInDictionary(let word) {
						Game.showAlert(targetClass: self, title: "\(word) is not in the dictionary. Try again")
					} catch let error {
						fatalError("\(error)")
					}
                }
				else {
					Game.showAlert(targetClass: self, title: "You must enter a word",message: "Field cannot be left blank")
				}
            }
        }
    }
    
    func textFieldShouldReturn(answerTextField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
        startButton.hidden = false
		difficultyControl.hidden = false
        return true
    }
	

}

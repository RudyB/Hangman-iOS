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
    @IBAction func resignKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
	// MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden = true;
		difficultyControl.isHidden = true;
        self.answerTextField.delegate = self;
		self.answerTextField.becomeFirstResponder()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override var prefersStatusBarHidden : Bool {
		return true;
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "launchTwoPlayerGameSegue" {
            
            if let destination = segue.destination as? GameViewController, let answer = answerTextField.text {
                if answer != "" {
					do {
						guard let difficultyControlSegmentTitle = difficultyControl.titleForSegment(at: difficultyControl.selectedSegmentIndex),
							let difficulty = Game.Difficulty(rawValue: difficultyControlSegmentTitle) else {
							fatalError()
						}
						destination.game = try Game(answer: answer, difficulty: difficulty)
						destination.getDictionaryDefinition()
						answerTextField.text = ""
						startButton.isHidden = true
						difficultyControl.isHidden = true
					} catch Game.GameError.notAValidWord {
						Game.showAlert(targetClass: self, title: "Not a valid word. Try again")
					} catch Game.GameError.wordNotInDictionary(let word) {
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
    
    func textFieldShouldReturn(_ answerTextField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
        startButton.isHidden = false
		difficultyControl.isHidden = false
        return true
    }
	

}

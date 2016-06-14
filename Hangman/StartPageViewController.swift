//
//  StartPageViewController.swift
//  Hangman
//
//  Created by Rudy Bermudez on 5/31/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController, UITextFieldDelegate{
    

    @IBOutlet weak var answerTextField: UITextField!
	
    @IBAction func resignKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.hidden = true;
        self.answerTextField.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func prefersStatusBarHidden() -> Bool {
		return true;
	}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "launchGameSegue" {
            
            if let destination = segue.destinationViewController as? GameViewController, let answer = answerTextField.text {
                if !answer.isEmpty {
					do {
						destination.game = try Game(answer: answer)
						answerTextField.text = ""
						startButton.hidden = true
					} catch Game.GameError.NotAValidWord {
						showAlert(title: "Not a valid word. Try again")
					} catch let error {
						fatalError("\(error)")
					}
                }
				else {
					showAlert(title: "You must enter a word",message: "Field cannot be left blank")
				}
            }
        }
    }
    
    func textFieldShouldReturn(answerTextField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
        startButton.hidden = false
        return true
    }
	
	func showAlert(title title: String, message: String? = nil, style: UIAlertControllerStyle = .Alert, action:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil) ) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		alert.addAction(action)
		presentViewController(alert, animated: true, completion: nil)
	}

}

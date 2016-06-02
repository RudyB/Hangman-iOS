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
    
    @IBAction func startButton(sender: UIButton) {}
    
    @IBAction func resignKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.hidden = true;
        self.answerTextField.delegate = self;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startGameSegue" {
            
            if let destination = segue.destinationViewController as? GameViewController, let answer = answerTextField.text {
                if !answer.isEmpty {
                    destination.game = Game(answer: answer)
                }
            }
        }

        
    }
    
    func textFieldShouldReturn(answerTextField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
        startButton.hidden = false
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

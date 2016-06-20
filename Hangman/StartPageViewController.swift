//
//  StartPageViewController.swift
//  Hangman
//
//  Created by Rudy Bermudez on 6/19/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import UIKit


class StartPageViewController: UIViewController {

	// MARK: - Class Variables
	private var singlePlayerDifficulty: Game.Difficulty?
	private var foregroundNotification: NSObjectProtocol!
	
	// MARK: - IB Outlets/Actions
	@IBOutlet weak var singlePlayerButton: UIButton!
	
	@IBAction func startSinglePlayerGame() {
		let easyDifficulty = UIAlertAction(title: "Easy", style: .Default, handler: getDifficulty)
		let mediumDifficulty = UIAlertAction(title: "Medium", style: .Default, handler: getDifficulty)
		let hardDifficulty = UIAlertAction(title: "Hard", style: .Default, handler: getDifficulty)
		let cancelAlert = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		Game.showAlert(targetClass: self, title: "Please Choose a Difficulty", actionList: [easyDifficulty, mediumDifficulty,hardDifficulty, cancelAlert])
	}
	
	// MARK: - Default Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		foregroundNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
			[unowned self] notification in
			self.checkForInternetConnection()
		}
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(foregroundNotification)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		checkForInternetConnection()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true;
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "launchSinglePlayerGameSegue" {
			if Reachability.isConnectedToNetwork() == false {
				Game.showAlert(targetClass: self, title: "No Connection to Internet", message: "Single Player is Disabled")
			} else {
				if let destination = segue.destinationViewController as? GameViewController, let singlePlayerDifficulty = singlePlayerDifficulty  {
					WordAPI.generateRandomWord(wordDifficulty: singlePlayerDifficulty, completionHandler: {
						word in
						dispatch_async(dispatch_get_main_queue()) {
							do {
								print(word)
								destination.game = try Game(answer: word, difficulty: singlePlayerDifficulty)
								destination.updateDisplay()
								destination.getDictionaryDefinition()
								destination.hintButton.hidden = false
								
							} catch {
								Game.showAlert(targetClass: self, title: "The Game Could Not Be Loaded",message: "Please Try Again")
							}
						}
					})
				}
			}
			}
			
	}
	
	
	func checkForInternetConnection() {
		print("Checking Reachability")
		if Reachability.isConnectedToNetwork() == true {
			singlePlayerButton.hidden = false
		} else {
			singlePlayerButton.hidden = true
			Game.showAlert(targetClass: self, title: "No Active Connection to Internet", message: "Single Player has been disabled")
			
		}
	}
	
	
	// MARK: - UIAlertAction Handlers
	
	func getDifficulty(sender: UIAlertAction) {
		if let difficultyOption = sender.title, let game = Game.Difficulty(rawValue: difficultyOption){
			singlePlayerDifficulty = game
			performSegueWithIdentifier("launchSinglePlayerGameSegue", sender: self)
		}
		
	}
	
}

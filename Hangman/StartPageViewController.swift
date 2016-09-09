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
	fileprivate var singlePlayerDifficulty: Game.Difficulty?
	fileprivate var foregroundNotification: NSObjectProtocol!
	
	// MARK: - IB Outlets/Actions
	@IBOutlet weak var singlePlayerButton: UIButton!
	
	@IBAction func startSinglePlayerGame() {
		let easyDifficulty = UIAlertAction(title: "Easy", style: .default, handler: getDifficulty)
		let mediumDifficulty = UIAlertAction(title: "Medium", style: .default, handler: getDifficulty)
		let hardDifficulty = UIAlertAction(title: "Hard", style: .default, handler: getDifficulty)
		let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		Game.showAlert(targetClass: self, title: "Please Choose a Difficulty", actionList: [easyDifficulty, mediumDifficulty,hardDifficulty, cancelAlert])
	}
	
	// MARK: - Default Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
			[unowned self] notification in
			self.checkForInternetConnection()
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(foregroundNotification)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		checkForInternetConnection()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override var prefersStatusBarHidden : Bool {
		return true;
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "launchSinglePlayerGameSegue" {
			if Reachability.isConnectedToNetwork() == false {
				Game.showAlert(targetClass: self, title: "No Connection to Internet", message: "Single Player is Disabled")
			} else {
				if let destination = segue.destination as? GameViewController, let singlePlayerDifficulty = singlePlayerDifficulty  {
					WordAPI.generateRandomWord(wordDifficulty: singlePlayerDifficulty, completionHandler: {
						word in
						DispatchQueue.main.async {
							do {
								print(word)
								destination.game = try Game(answer: word, difficulty: singlePlayerDifficulty)
								destination.updateDisplay()
								destination.getDictionaryDefinition()
								destination.hintButton.isHidden = false
								
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
			singlePlayerButton.isHidden = false
		} else {
			singlePlayerButton.isHidden = true
			Game.showAlert(targetClass: self, title: "No Active Connection to Internet", message: "Single Player has been disabled")
			
		}
	}
	
	
	// MARK: - UIAlertAction Handlers
	
	func getDifficulty(_ sender: UIAlertAction) {
		if let difficultyOption = sender.title, let game = Game.Difficulty(rawValue: difficultyOption){
			singlePlayerDifficulty = game
			performSegue(withIdentifier: "launchSinglePlayerGameSegue", sender: self)
		}
		
	}
	
}

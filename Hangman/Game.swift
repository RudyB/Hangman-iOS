//
//  Game.swift
//  Hangman
//
//  Created by Rudy Bermudez on 5/31/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import UIKit

class Game {
	// MARK: - Class Variables
	var maxMisses:Int
    var answer:String
    var hits:String
    var misses:String
	let difficulty: Game.Difficulty
	static let validLetters = CharacterSet.letters
    
	init(answer:String, difficulty:Difficulty) throws {
        self.answer = try Game.validateAnswer(answer: answer);
        self.hits = "";
        self.misses = "";
		self.maxMisses = difficulty.guesses()
		self.difficulty = difficulty
    }
	
	// MARK: - Class Functions
    func applyGuess(guess:String?) throws -> Bool?{
        guard let letter = try validateGuess(guess: guess) else {
            return nil
        }
        let isHit = answer.characters.contains(letter)
        if isHit {
            hits.append(letter);
        } else {
            misses.append(letter);
        }
        return isHit;
    }
	
	static func validateAnswer(answer: String) throws -> String {
		for letter in answer.trim().unicodeScalars {
			if !validLetters.contains(UnicodeScalar(letter.value)!) {
				throw GameError.notAValidWord
			}
		}
		return answer.trim().lowercased()
	}
	
	
    func validateGuess(guess:String?) throws -> Character?{
        guard let guess = guess, let firstLetter = guess.unicodeScalars.first, let firstCharacter = guess.characters.first else {
            return nil;
        }
		
        if (!Game.validLetters.contains(UnicodeScalar(firstLetter.value)!)) {
            throw GameError.characterIsNotLetter
        } else if (misses.characters.contains(firstCharacter) || hits.characters.contains(firstCharacter)) {
			throw GameError.letterAlreadyGuessed(letter: String(firstCharacter))
        }
		return firstCharacter

    }
    
    func getCurrentProgress() -> String {
        var progress = "";
        for letter in answer.characters {
            var display = "-";
            if hits.characters.contains(letter) {
                display = String.init(letter);
            }
            progress += display;
        }
        return progress;
        
    }
    
    func isSolved() -> Bool {
        return getCurrentProgress() == answer;
    }
    
    func getRemainingTries() -> Int {
        return maxMisses - misses.characters.count;
    }
    
    func getAnswer() -> String {
        var finalAnswer = "Game is not over yet";
        if (isSolved() || misses.characters.count >= maxMisses) {
            finalAnswer = answer;
        }
        return finalAnswer;
    }
    
    func getMisses() -> String {
        var wrongGuesses = "";
        for letter in misses.characters {
            wrongGuesses += String(letter) + " ";
        }
        return wrongGuesses.uppercased();
    }
	
	
	// MARK: - Helper View Controller Functions
	
	static func showAlert(targetClass:UIViewController, title: String, message: String? = nil, style: UIAlertControllerStyle = .alert, actionList:[UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)] ) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		for action in actionList {
			alert.addAction(action)
		}
		targetClass.present(alert, animated: true, completion: nil)
	}
    
	// MARK: - Exceptions
	
	enum GameError: Error {
		case letterAlreadyGuessed(letter: String)
		case characterIsNotLetter
		case notAValidWord
		case wordNotInDictionary(word: String)
	}
	
	// MARK: - Difficulty
	enum Difficulty: String {
		case Easy
		case Medium
		case Hard
		
		func guesses() -> Int {
			switch self {
			case .Easy:
				return 10
			case .Medium:
				return 8
			case .Hard:
				return 6
			}
		}
		
		func corpusLevel() -> Int {
			switch self {
			case .Easy:
				return 900000
			case .Medium:
				return 90000
			case .Hard:
				return 9000
			}
		}
	}
}

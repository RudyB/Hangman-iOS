//
//  Game.swift
//  Hangman
//
//  Created by Rudy Bermudez on 5/31/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import Foundation

class Game {
	var maxMisses:Int
    var answer:String
    var hits:String
    var misses:String
	static let validLetters = NSCharacterSet.letterCharacterSet()
    
	init(answer:String, difficulty:Difficulty) throws {
        self.answer = try Game.validateAnswer(answer);
        self.hits = "";
        self.misses = "";
		self.maxMisses = difficulty.guesses()
    }
    
    func applyGuess(guess:String?) throws -> Bool?{
        guard let letter = try validateGuess(guess) else {
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
		for letter in answer.unicodeScalars {
			if !validLetters.longCharacterIsMember(letter.value) {
				throw GameError.NotAValidWord
			}
		}
		return answer.lowercaseString
	}
	
	
    func validateGuess(guess:String?) throws -> Character?{
        guard let guess = guess, let firstLetter = guess.unicodeScalars.first, let firstCharacter = guess.characters.first else {
            return nil;
        }
		
        if (!Game.validLetters.longCharacterIsMember(firstLetter.value)) {
            throw GameError.CharacterIsNotLetter
        } else if (misses.characters.contains(firstCharacter) || hits.characters.contains(firstCharacter)) {
			throw GameError.LetterAlreadyGuessed(letter: String(firstCharacter))
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
        return wrongGuesses.uppercaseString;
    }
    
	// Exceptions
	
	enum GameError: ErrorType {
		case LetterAlreadyGuessed(letter: String)
		case CharacterIsNotLetter
		case NotAValidWord
	}
	
	// Difficulty
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
	}
}
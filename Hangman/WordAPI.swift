//
//  WordAPI.swift
//  Hangman
//
//  Created by Rudy Bermudez on 6/19/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import Foundation

class WordAPI {
	
	enum ConnectionError: Error {
		case connectivityError
	}
	
	static let API_KEY = "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
	
	
	static func generateRandomWord(wordDifficulty: Game.Difficulty, completionHandler: @escaping (_ word: String) -> ()) {
		
		let corpusCount = wordDifficulty.corpusLevel()
		let requestURL: URL = URL(string: "https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&excludePartOfSpeech=family-name&minCorpusCount=\(corpusCount)&maxCorpusCount=-1&minDictionaryCount=5&maxDictionaryCount=-1&minLength=5&maxLength=8&api_key=\(API_KEY)")!
		let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
		let session = URLSession.shared
		let task = session.dataTask(with: urlRequest as URLRequest){
			(data, response, error) -> Void in
			let httpResponse = response as! HTTPURLResponse
			let statusCode = httpResponse.statusCode
			
			if (statusCode == 200) {
				do{
					let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String:AnyObject]
					if let word = json?["word"] as? String {
						completionHandler(word)
					}
					
				}catch {
					print("Error with Json: \(error)")
				}
				
			}}
		task.resume()
	}
	
	static func getDictionaryDefinition(wordToSearch: String, completionHandler: @escaping (_ definition: String) -> ()) {
		let requestURL: URL = URL(string: "https://api.wordnik.com/v4/word.json/\(wordToSearch)/definitions?limit=1&includeRelated=false&useCanonical=false&includeTags=false&api_key=\(API_KEY)")!
		let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
		let session = URLSession.shared
		let task = session.dataTask(with: urlRequest as URLRequest) {
			(data, response, error) -> Void in
			let httpResponse = response as! HTTPURLResponse
			let statusCode = httpResponse.statusCode
			
			if (statusCode == 200) {
				do{
					let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String:AnyObject]]
					if let definition = json?[0]["text"] as? String {
						completionHandler(definition)
					}
					
				}catch {
					print("Error with Json: \(error)")
				}
				
			}}
		task.resume()
	}
}

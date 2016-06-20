//
//  WordAPI.swift
//  Hangman
//
//  Created by Rudy Bermudez on 6/19/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import Foundation

class WordAPI {
	
	enum Error: ErrorType {
		case ConnectivityError
	}
	
	static let API_KEY = "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
	
	
	static func generateRandomWord(completionHandler: (word: String) -> ()) {
		let requestURL: NSURL = NSURL(string: "https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&excludePartOfSpeech=family-name&minCorpusCount=9000&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=\(API_KEY)")!
		let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(urlRequest){
			(data, response, error) -> Void in
			let httpResponse = response as! NSHTTPURLResponse
			let statusCode = httpResponse.statusCode
			
			if (statusCode == 200) {
				do{
					let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
					if let word = json["word"] as? String {
						completionHandler(word: word)
					}
					
				}catch {
					print("Error with Json: \(error)")
				}
				
			}}
		task.resume()
	}
	
	static func getDictionaryDefinition(wordToSearch wordToSearch: String, completionHandler: (definition: String) -> ()) {
		let requestURL: NSURL = NSURL(string: "https://api.wordnik.com/v4/word.json/\(wordToSearch)/definitions?limit=1&includeRelated=false&useCanonical=false&includeTags=false&api_key=\(API_KEY)")!
		let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(urlRequest){
			(data, response, error) -> Void in
			let httpResponse = response as! NSHTTPURLResponse
			let statusCode = httpResponse.statusCode
			
			if (statusCode == 200) {
				do{
					let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
					if let definition = json[0]["text"] as? String {
						completionHandler(definition: definition)
					}
					
				}catch {
					print("Error with Json: \(error)")
				}
				
			}}
		task.resume()
	}
}
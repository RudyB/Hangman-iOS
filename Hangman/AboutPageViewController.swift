//
//  AboutPageViewController.swift
//  Hangman
//
//  Created by Rudy Bermudez on 6/19/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	override func prefersStatusBarHidden() -> Bool {
		return true;
	}
	
}

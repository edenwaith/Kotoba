//
//  DictionaryViewController
//  Dictionary
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController, UISearchBarDelegate
{
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var dictionaryContainer: UIView!
	
	var referenceViewController: UIReferenceLibraryViewController?

	override func viewDidAppear(animated: Bool)
	{
		// Increase size of font and height of search bar
		let helveticaNeueBig = UIFont(name: "Helvetica Neue", size: 24)
		for subview in findAllSubviews(self.searchBar)
		{
			if subview is UITextField
			{
				let textField = subview as UITextField
				textField.font = helveticaNeueBig
				textField.bounds.size.height = 88
			}
		}
		
		// Show the keyboard on launch, so you can start typing right away
		self.searchBar.becomeFirstResponder()
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
	{
		// Delay slightly to make typing smoother
		Timer("type delay", 1.0)
		{
			// Check if dictionary contains typed word
			let searchText = searchBar.text
			if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(searchText)
			{
				// Remove the existing dictionary view controller, if it exists
				if let refVC = self.referenceViewController
				{
					refVC.removeFromParentViewController()
					refVC.view.removeFromSuperview()
				}
				
				// Create the dictionary view controller
				let refVC = UIReferenceLibraryViewController(term: searchText)
				
				// Display the dictionary view inside the container view
				self.addChildViewController(refVC)
				refVC.view.frame = self.dictionaryContainer.frame
				self.view.addSubview(refVC.view)
				refVC.didMoveToParentViewController(self)
				
				// Remember for later
				self.referenceViewController = refVC
			}
		}
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		// Hide keyboard
		searchBar.resignFirstResponder()
	}
}

// Cheater's function to rummage through the subviews of the given UIView
func findAllSubviews(view: UIView) -> [UIView]
{
	var subviews = [UIView]()
	for subview in view.subviews
	{
		subviews.append(subview as UIView)
		subviews.extend(findAllSubviews(subview as UIView))
	}
	return subviews
}

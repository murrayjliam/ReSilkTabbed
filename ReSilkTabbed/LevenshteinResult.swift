//
//  LevenshteinDistanceResult.swift
//  ReSilkTabbed
//
//  Created by Liam Murray on 25/02/2019.
//  Copyright © 2019 Liam Murray. All rights reserved.
//

import UIKit
import Foundation

class LevenshteinResult: UIViewController {
    //Creating a Reference for the TableView in the first ViewController
    
    @IBOutlet weak var levenResult: UILabel!
    @IBOutlet weak var userString1: UILabel!
    @IBOutlet weak var userString2: UILabel!
    //CREATE STRUYCTURE HERE FOR THE STRINGS AND RESULT
    //DISPLAY WITH LABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levenResult.text = String(userInputResults.resultLev)
        userString1.text = String(userInputResults.userText1!)
        userString2.text = String(userInputResults.userText2!)
        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.accBlue)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
}

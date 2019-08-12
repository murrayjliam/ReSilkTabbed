//
//  AreaDisplay.swift
//  ReSilkTabbed
//
//  Created by Liam Murray on 27/03/2019.
//  Copyright © 2019 Liam Murray. All rights reserved.
//



import UIKit
import Foundation

class AreaDisplay: UIViewController {
    //Creating a Reference for the TableView in the first ViewController

    @IBOutlet weak var selectedCity: UILabel!
    @IBOutlet weak var selectedCounty: UILabel!
    //CREATE STRUYCTURE HERE FOR THE STRINGS AND RESULT
    //DISPLAY WITH LABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCity.text = aCity
        selectedCounty.text = bCity
        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.accBlue)
        
    }
    
}

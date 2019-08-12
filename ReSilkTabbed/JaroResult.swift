//
//  JaroResult.swift
//  ReSilkTabbed
//
//  Created by Liam Murray on 12/03/2019.
//  Copyright © 2019 Liam Murray. All rights reserved.
//

import UIKit

class JaroResult: UIViewController {
   
    @IBOutlet weak var jaroResult: UILabel!
    @IBOutlet weak var userString1: UILabel!
    @IBOutlet weak var userString2: UILabel!
    //CREATE STRUYCTURE HERE FOR THE STRINGS AND RESULT
    //DISPLAY WITH LABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jaroResult.text = String(userInputResults.resultJaro)
        userString1.text = String(userInputResults.userText1!)
        userString2.text = String(userInputResults.userText2!)
        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.accBlue)
    }

}

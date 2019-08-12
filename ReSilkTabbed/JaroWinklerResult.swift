//
//  JaroWinklerResult.swift
//  ReSilkTabbed
//
//  Created by Liam Murray on 12/03/2019.
//  Copyright © 2019 Liam Murray. All rights reserved.
//

import UIKit

class JaroWinklerResult: UIViewController {
    
    @IBOutlet weak var userString1: UILabel!
    @IBOutlet weak var userString2: UILabel!
    @IBOutlet weak var jaroWinkResult: UILabel!
    //CREATE STRUYCTURE HERE FOR THE STRINGS AND RESULT
    //DISPLAY WITH LABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jaroWinkResult.text = String(userInputResults.resultJaroWink)
        userString1.text = String(userInputResults.userText1!)
        userString2.text = String(userInputResults.userText2!)
        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.accBlue)
    }
    
}

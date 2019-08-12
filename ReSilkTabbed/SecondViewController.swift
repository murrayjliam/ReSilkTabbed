//
//  SecondViewController.swift
//  ReSilkTabbed
//
//  Created by Liam Murray on 21/02/2019.
//  Copyright © 2019 Liam Murray. All rights reserved.
//
import UIKit
import Foundation


struct weightingStruct {
    let weight1: Double
    let weight2: Double
    let weight3: Double
}
var resultWeightings = weightingStruct(weight1: 0.1, weight2: 0.45, weight3: 0.45)

/*
 Declaring empty String global variables
 These Variables will pass in the data from the users selected Report
 Then they will be called within the second View Controler
 The data such as the Paper's title, authors. dates, etc will presented to the user
 */
var userInputResults = userInputStruct(userText1: "", userText2: "", resultLev: 0, resultJaro: 0, resultJaroWink: 0, resultWeighted: 0)

//Strings/Results Structure
struct userInputStruct {
    var userText1: String?
    var userText2: String?
    var resultLev: Float
    var resultJaro: Double
    var resultJaroWink: Double
    var resultWeighted: Double
}

//Instansiating small variables for easier calls later
let lev = LevenshteinDistance()
let jar = JaroDistance()
let jarW = JaroWinklerDistance()
let all = WeightingDistance()


/// The Code implemented here is re-purposed from
/// https://gist.github.com/automactic/f8e1d26c3c23ddbc5b8c2151f119d663
class LevenshteinDistance {
    //Instantiating a Disctionary set of vsriables which will be known as the "cache" for the Levenshtein Distance
    //Will be a set of Sub-Strings with a key of integers
    private(set) var cache = [Set<String.SubSequence>: Int]()
    
    /// Function to calculate the Levenshtein Distance of two Strings
    /// Passing in two SubStrings to be compared
    ///
    /// - Parameters:
    ///   - a: First String to be given
    ///   - b: Second String to be given
    /// - Returns: The value returned for this method is an integer which is calculated by the amount of edits needed to change 1st string to 2nd string
    func levenshteinDistance(s1: String.SubSequence, s2: String.SubSequence) -> Int {
        //Creating a vriable 'Key' and setting it to the amount of Strings entered
        let key = Set([s1, s2])
        /*
         -  Setting a distance variable to check between the 2 keys in the string cahce
         -  If the distance is matching then we return 0
         -  If it is not the same we set the distance to an Int
         If both the count of a and b is equal to 0
         We return an absolute value where we minus the count of the strings
         -  If the count is different we check if the first characters of each string are matching
         We then return the calculateDistance function
         Were we take the A String and start creating an index of the characters
         -  Repeat with B String
         */
        if let distance = cache[key] {
            return distance
        } else {
            let distance: Int = {
                if s1.count == 0 || s2.count == 0 {
                    return abs(s1.count - s2.count)
                } else if s1.first == s2.first {
                    return levenshteinDistance(s1: s1[s1.index(after: s1.startIndex)...], s2: s2[s2.index(after: s2.startIndex)...])
                    /*
                     If the previoua checks fail we then start to calculate the differences in both Stirngs
                     We create an 'add' variable where ......
                     We create an 'replace' variable where .....
                     We create an 'delete' variable where .... 
                     */
                } else {
                    let add = levenshteinDistance(s1: s1, s2: s2[s2.index(after: s2.startIndex)...])
                    let replace = levenshteinDistance(s1: s1[s1.index(after: s1.startIndex)...], s2: s2[s2.index(after: s2.startIndex)...])
                    let delete = levenshteinDistance(s1: s1[s1.index(after: s1.startIndex)...], s2: s2)
                    return min(add, replace, delete) + 1
                }
            }()
            cache[key] = distance
            return distance
        }
    }
}

///The code implemented here is repurposed from
/// https://rosettacode.org/wiki/Jaro_distance#Swift
/// This use of code adheres to the GNU Free Documentation License
/// The use of code here is non-commercial and is implemented for research purposes only
class JaroDistance {
    /// The Jaro Distance is given as, ɗ𝑗, between two given strings, 𝑠1 and 𝑠2.
    /// Gives count of each string
    /// Calculates 𝑚 - the number of matching characters (Characters can only be considered a match if they are either exactly the same or they are no farther than the distance of the length of the largest string, halved - 1)
    /// Calculates 𝓉 - the number of transpositions of, halved
    ///
    /// - Parameters:
    ///   - a: First string given by user
    ///   - b: Second tring given by user
    /// - Returns: Returns Jaro Distance given two strings, in double
    func jaroDistance(s1: String, s2: String) -> Double {
        let s1_len = s1.count
        let s2_len = s2.count
        var matchDistance = 0
        var s1Matches = [Bool]()
        var s2Matches = [Bool]()
        var charMatches = 0.0
        var transpositions = 0.0
        var k = 0
        
        if s1_len == 0 && s2_len == 0 {
            return 1.0
        }
        if s1_len == 0 || s2_len == 0 {
            return 0.0
        }
        
        if s1_len == 1 && s2_len == 1 {
            matchDistance = 1
        } else {
            matchDistance = ([s1_len, s2_len].max()!/2) - 1
        }
        for _ in 1...s1_len {
            s1Matches.append(false)
        }
        for _ in 1...s2_len {
            s2Matches.append(false)
        }
        for i in 0...s1_len - 1 {
            let start = [0, (i-matchDistance)].max()!
            let end = [(i + matchDistance), s2_len-1].min()!
            if start > end {
                break
            }
            for j in start...end {
                if s2Matches[j] {
                    continue
                }
                if s1[String.Index.init(encodedOffset: i)] != s2[String.Index.init(encodedOffset: j)] {
                    continue
                }
                // We must have a match
                s1Matches[i] = true
                s2Matches[j] = true
                charMatches += 1
                break
            }
        }
        
        if charMatches == 0 {
            return 0.0
        }
        for i in 0...s1_len-1 {
            if !s1Matches[i] {
                continue
            }
            while !s2Matches[k] {
                k += 1
            }
            if s1[String.Index.init(encodedOffset: i)] != s2[String.Index.init(encodedOffset: k)] {
                transpositions += 1
            }
            k += 1
        }
        let dj = (charMatches / Double(s1_len) + charMatches / Double(s2_len) + (charMatches - (transpositions / 2)) / charMatches) / 3
        return dj
    }
}

/// The Code here is re-purposed from
/// https://github.com/autozimu/StringMetric.swift/blob/master/LICENSE.txt
/// MIT License
/// Copyright (c) 2016 Junfeng Li <autozimu@gmail.com>

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
class JaroWinklerDistance {
    /// Calculate Jaro Distance
    /// Jaro–Winkler similarity uses a prefix scale 𝓅, which gives more positive ratings to strings that match from the beginning for a set prefix length ℓ
    /// - Parameters:
    ///   - userString1: First String given by user
    ///   - userString2: Second String given by user
    /// - Returns: returns
    func jaroWinklerDistance(s1 :String, s2 :String) -> Double {
        let s1_len = s1.count
        let s2_len = s2.count
        let userSA1 = Array(s1)
        let userSA2 = Array(s2)
        if s1_len == 0 && s2_len == 0 {
            return 1.0
        }
        
        let matchingWindowSize = max(s1_len, s2_len) / 2 - 1
        var userString1Flags = Array(repeating: false, count: s1_len)
        var userString2Flags = Array(repeating: false, count: s2_len)
        
        // Count matching characters.
        var charMatches: Double = 0
        for i in 0..<s1_len {
            let left = max(0, i - matchingWindowSize)
            let right = min(s2_len - 1, i + matchingWindowSize)
            if left <= right {
                for j in left...right {
                    // Already has a match, or does not match
                    if userString2Flags[j] || userSA1[i] != userSA2[j] {
                        continue;
                    }
                    charMatches += 1
                    userString1Flags[i] = true
                    userString2Flags[j] = true
                    break
                }
            }
        }
        if charMatches == 0.0 {
            return 0.0
        }
        // Counting number of Transpositions
        var transpositions = 0.0
        var k = 0
        for i in 0..<s1_len {
            if (userString1Flags[i] == false) {
                continue
            }
            while (userString2Flags[k] == false) {
                k += 1
            }
            if (userSA1[i] != userSA2[k]) {
                transpositions += 1
            }
            k += 1
        }
        transpositions /= 2.0
        // Length  of common prefix.
        var commLen = 0.0
        for i in 0..<4 {
            if userSA1[i] == userSA2[i] {
                commLen += 1
            } else {
                break
            }
        }
        let dj = (charMatches / Double(s1_len) + charMatches / Double(s2_len) + (charMatches - transpositions) / charMatches) / 3
        let p = 0.1
        let jaroWinkDis = dj + commLen * p * (1 - dj)
        return jaroWinkDis;
    }
}

class WeightingDistance {
    
    /// Imports all wieghtings + distance scores
    /// Then calculates a normalised score given by the weightings multiplied by each result
    /// - Returns: Return value is a double
    func similarityScore() -> Double {
        let w1 = resultWeightings.weight1
        let w2 = resultWeightings.weight2
        let w3 = resultWeightings.weight3
        let rL = userInputResults.resultLev
        let rJ = userInputResults.resultJaro
        let rJW = userInputResults.resultJaroWink
        let simScore = (w1 * Double(rL) + w2 * Double(rJ) + w3 * Double(rJW)) / 3
        return simScore
    }
}


class SecondViewController: UIViewController, UITextFieldDelegate {
    //Referencing User input Text Fields
    @IBOutlet weak var userInput1: UITextField!
    @IBOutlet weak var userInput2: UITextField!
    
    /*
     Referencing the button to run and calculate the Levenshtein Distance
     Given two strings by the user
     The Levenshtein Distance will be calculated 
     */
    @IBAction func levenshteinButton(_ sender: Any) {
        guard let uText1 = userInput1.text else { return }
        guard let uText2 = userInput2.text else { return }
        userInputResults.userText1 = uText1
        userInputResults.userText2 = uText2
        let result = lev.levenshteinDistance(s1: String.SubSequence(uText1), s2: String.SubSequence(uText2))
        var strLen: Int
        if uText1.count > uText2.count {
            strLen = uText1.count
        } else {
            strLen = uText2.count
        }
        let resultL: Float = Float(result) / Float(strLen)
        userInput1.text = userInputResults.userText1
        userInput2.text = userInputResults.userText2
        userInputResults.resultLev = resultL
        print(resultL)
        self.view.endEditing(true)
        performSegue(withIdentifier: "toLevenshtein", sender: nil)
    }
    
    /*x
     Referencing the button to run and calculate the Jaro Distance
     Given two strings by the user
     */
    @IBAction func jaroButton(_ sender: Any) {
        guard let uText1 = userInput1.text else { return }
        guard let uText2 = userInput2.text else { return }
        userInputResults.userText1 = uText1
        userInputResults.userText2 = uText2
        let resultJ = jar.jaroDistance(s1: uText1, s2: uText2)
        userInput1.text = userInputResults.userText1
        userInput2.text = userInputResults.userText2
        userInputResults.resultJaro = resultJ
        print(resultJ)
        self.view.endEditing(true)
    }
    /*
     Referencing the button to run and calculate the Jaro-Winkler Distance
     Given two strings by the user
     */
    @IBAction func jaroWinkButton(_ sender: Any) {
        guard let uText1 = userInput1.text else { return }
        guard let uText2 = userInput2.text else { return }
        userInputResults.userText1 = uText1
        userInputResults.userText2 = uText2
        let resultJW = jarW.jaroWinklerDistance(s1: uText1, s2: uText2)
        userInputResults.resultJaroWink = resultJW
        print(resultJW)
        self.view.endEditing(true)
    }
    
    /// Button which runs algorithm to calculate comparisson between both user strings
    /// Runs all three algorithm stores their values then runs the weighted algorithm against their results
    /// - Parameter sender: Any
    @IBAction func calculateAllButton(_ sender: Any) {
        guard let uText1 = userInput1.text else { return }
        guard let uText2 = userInput2.text else { return }
        userInputResults.userText1 = uText1
        userInputResults.userText2 = uText2
        let result = lev.levenshteinDistance(s1: String.SubSequence(uText1), s2: String.SubSequence(uText2))
        var strLen: Int
        if uText1.count > uText2.count {
            strLen = uText1.count
        } else {
            strLen = uText2.count
        }
        let resultL: Float = Float(result) / Float(strLen)
        let resultJ = jar.jaroDistance(s1: uText1, s2: uText2)
        let resultJW = jarW.jaroWinklerDistance(s1: uText1, s2: uText2)
        userInputResults.resultJaro = resultJ
        userInputResults.resultLev = resultL
        userInputResults.resultJaroWink = resultJW
        let resultAll = all.similarityScore()
        userInputResults.resultWeighted = resultAll
        print(resultAll)
    }
    
    @objc func buttonDoneClicked() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let keyToolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(buttonDoneClicked))
        keyToolBar.sizeToFit()
        keyToolBar.setItems([doneButton], animated: true)
        userInput1.inputAccessoryView = keyToolBar
        userInput2.inputAccessoryView = keyToolBar
        userInput1?.delegate = self
        userInput2?.delegate = self
        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.accBlue)
    }
}

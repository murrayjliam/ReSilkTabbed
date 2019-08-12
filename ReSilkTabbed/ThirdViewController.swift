//
//  ThirdViewController.swift
//  ReSilkTabbed
//
//  Created by Liam Murray on 21/02/2019.
//  Copyright © 2019 Liam Murray. All rights reserved.
//

import UIKit
import Foundation

var aCity = ""
var bCity = ""
//Passing in the GeoNames JSON data into another variable to make it easier to call
var selectedArea = [ThirdViewController.geoNamesCounty]()
var dataRes: [(string1: String, string2: String, result: Double)] = []

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // GeoNames JSON Structure
    struct geoNamesCounty: Decodable {
        let CountryCode: String
        let PostCode: String
        let City: String
        let Country: String
        let CountryAbv: String
        let County: String?
        let District: String
        let AreaCode: String
        let Latitude: String
        let Longitude: String
    }
    // GOV data JSON Structure
    struct govCounty: Decodable {
        let objectid: String
        let ctyua16cd: String
        let ctyua16nm: String
        let ctyua16nmw: String
        let bng_e: String
        let bng_n: String
        let long: String
        let lat: String
        let st_areashape: String
        let st_lengthshape: String
    }
    // Office for National Statistics JSON Structure
    struct onsCounty: Decodable {
        let AreaCode: String
        let AreaName: String
        let reg: String
        let WorkingHouseholdsPCTG: String
        let MixedHouseholdsPCTG: String
        let WorklessHouseholdsPCTG: String
        let PCTGPeopleWorklessHouseholds: String
        let PCTGChildrenWorklessHouseholds: String
    }
    
    //Easier structures to call JSON items
    struct geoNamesCounties: Decodable {
        let geoNames2: [geoNamesCounty]
    }
    struct govCounties: Decodable {
        let govNames2: [govCounty]
    }
    struct onsCounties: Decodable {
        let onsNames2: [onsCounty]
    }
    //Passing in the JSON data into another variable to make it easier to call
    var geoCityList = [geoNamesCounty]()
    var govCityList = [govCounty]()
    var onsCityList = [onsCounty]()
    
    // Instantiating an array to store exact matches and partial matches
    var exactMatchArr = [Double]()
    var partialMatch = [Double]()
    
    // Referenceing the data table from the view to the model
    @IBOutlet weak var resultTable: UITableView!

    
    // Retrieving the JSON Information/Data
    // Retrieving JSON file
    func retrieveJSON() {
        let urlString = "https://student.csc.liv.ac.uk/~sglmurra/GEONamesCounties.json"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    //decoder.dateDecodingStrategy = .
                    let cityList = try
                        decoder.decode(geoNamesCounties.self, from: jsonData)
                    self.geoCityList = cityList.geoNames2
                    //Sorting smalling to largesrt
                    //self.ordered.sort{$0 < $1}
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                DispatchQueue.main.async {
                }
                }.resume()
        }
    }
    
    // Retrieving the JSON Information/Data
    func retrieveJSON2() {
        let urlString = "https://student.csc.liv.ac.uk/~sglmurra/GOVCounties2.json"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    //decoder.dateDecodingStrategy = .
                    let cityList = try
                        decoder.decode(govCounties.self, from: jsonData)
                    self.govCityList = cityList.govNames2
                    //Sorting smalling to largest
                    //self.ordered.sort{$0 < $1}
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                DispatchQueue.main.async {
                }
                }.resume()
        }
    }
    // Retrieving the JSON Information/Data
    func retrieveJSON3() {
        let urlString = "https://student.csc.liv.ac.uk/~sglmurra/ONSCounties.json"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    //decoder.dateDecodingStrategy = .
                    let cityList = try
                        decoder.decode(onsCounties.self, from: jsonData)
                    self.onsCityList = cityList.onsNames2
                    //Sorting smalling to largesrt
                    //self.ordered.sort{$0 < $1}
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                DispatchQueue.main.async {
                }
                }.resume()
        }
    }
    
    /// Runs the JSON retrievers
    /// Runs checks against each data entity wanting to be checked
    /// Implementes the textual similairty algorithms against two entities
    /// Choose which algorithm by commenting out the disregarded algorithms
    /// Need to change the variables for areaCodes and areaCodes2
    /// Thresholds need to be changed with respect to chosen algorithm
    func compAreaCodes() {
        let start = CFAbsoluteTimeGetCurrent()
        // Run work from timestamp
        retrieveJSON()
        retrieveJSON2()
        retrieveJSON3()
        var count = 0
        var count2 = 0
        print("Retreived JSON \n")
        for areaCodes in self.geoCityList {
            count += 1
            for areaCodes2 in self.onsCityList{
                count2 += 1
                // ------------- Levenshtein Distance -------------
                let result = lev.levenshteinDistance(s1: String.SubSequence(areaCodes.AreaCode), s2: String.SubSequence(areaCodes2.AreaCode))
                var strLen: Int
                if areaCodes.AreaCode.count > areaCodes2.AreaCode.count {
                    strLen = areaCodes.AreaCode.count
                } else {
                    strLen = areaCodes2.AreaCode.count
                }
                let resultL = Float(result) / Float(strLen)
                // ------------- Levenshtein Distance -------------
                // - Jaro Distance
                let resultJ = jar.jaroDistance(s1: areaCodes.AreaCode, s2: areaCodes2.AreaCode)
                // - Jaro-Winkler Distance
                let resultJW = jarW.jaroWinklerDistance(s1: areaCodes.AreaCode, s2: areaCodes2.AreaCode)
                // ------------- Weighted Anchor Algorithm -------------
                userInputResults.resultLev = resultL // Storing result of Levenshtein into result structure to be called
                userInputResults.resultJaro = resultJ // Storing result of Jaro into result structure to be called
                userInputResults.resultJaroWink = resultJW // Storing result of Jaro-Winkler into result structure to be called
                let resultAll = all.similarityScore() // Assigning value of weighted score to a new variable
                userInputResults.resultWeighted = resultAll // Storing result of weighted algorithm into result structure to be called
                 // ------------- Weighted Anchor Algorithm -------------
                if resultAll == 0.3 {
                    exactMatchArr.append(resultAll)
                } else if resultAll >= 0.2 && resultAll <= 0.29 {
                    partialMatch.append(resultAll)
                }
                dataRes.append((string1: areaCodes.AreaCode, string2: areaCodes2.AreaCode, result: resultAll))
            }
        }
        dataRes = dataRes.sorted(by: {$0.result > $1.result})
        //Run Comparrison
        let diff = CFAbsoluteTimeGetCurrent() - start
        print("Took \(diff) seconds")
    }
    
    //Button to calculate the
    @IBAction func calculateDataByLev(_ sender: Any) {
        print("Pressed Button \n")
        compAreaCodes()
        resultTable.isHidden = false
        resultTable.reloadData()
        print("------------")
        //Change depending on data sets compared
        print("Running data sets GEO against GOV data: \(dataRes.count) results")
        print("\(exactMatchArr.count) exact Matches")
        print("\(partialMatch.count) partial Matches")
        print("------------")
    }
    
    
    /*
     Number of rows retrieved from  all the number of comparisons made
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRes.count
    }
    
    /*
     Tableview to display the Strings Compared
     When Provides a checkmark icon to comparissons with an Exact Match
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "resultsCell")
        //Retriving the strings compared and printing them alogn with the algorithm result
        let out = (" 1. \"\(dataRes[indexPath.row].string1)\" vs. 2. \"\(dataRes[indexPath.row].string2)\"")
        let res = ("Result = \(dataRes[indexPath.row].result)")
        print(out)
        cell.textLabel?.text = out
        cell.detailTextLabel?.text = res
        //Implemnenting a checkmark icon if there is an exact match
        if dataRes[indexPath.row].result == 0.3 {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    
    //Function on where a row is selected by the user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theBuild = dataRes[indexPath.row].string2
        //Array to store area names
        var areaNames = [ThirdViewController.geoNamesCounty]()
        //compare location with what is selected
        for anArea in self.geoCityList {
            if anArea.AreaCode == theBuild {
                if areaNames.count == 0 {
                    areaNames.append(anArea)
                } else {
                    areaNames[0] = anArea
                }
            }
        }
        let slectedAreaCode = areaNames[0]
        //Passing in the selected paper to the global Variables above
        aCity = slectedAreaCode.City
        bCity = slectedAreaCode.PostCode
        //Performing a segue to pass in the data from the original view to the next view
        performSegue(withIdentifier: "to Details", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Rounding the coners of the table
        resultTable.isHidden = true
        resultTable.layer.cornerRadius = 10.0
        resultTable.layer.masksToBounds = true
        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.accBlue)
    }
    
}

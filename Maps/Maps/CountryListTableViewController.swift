//
//  CountryListTableViewController.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class CountryListTableViewController: UITableViewController {

    let countriesList = ["Ukraine", "USA", "Canada", "Australia", "Germany"]
    var countries: [Country] = []
    var elementName: String = String()
    var countryName = String()
    //var bookAuthor = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.url(forResource: "regions", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        print(countries)
        print("!!!")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return countriesList.count
        }
       
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "deviceMemoryCell", for: indexPath) as! DeviceMemoryCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryListCell
            cell.countryNameLabel.text = countriesList[indexPath.row]
            return cell
        }
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "EUROPE"
        }
        return nil
    }
    
}

extension CountryListTableViewController: XMLParserDelegate {
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "region" {
            countryName = String()
            //bookAuthor = String()
        }

        self.elementName = elementName
    }

    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "region" {
            let country = Country(countryName: countryName)
            countries.append(country)
        }
    }

    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "name" {
                print(self.elementName)
                countryName += data
            }
//            else if self.elementName == "author" {
//                bookAuthor += data
//            }
        }
    }
    
}

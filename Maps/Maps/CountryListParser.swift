//
//  CountryListParser.swift
//  Maps
//
//  Created by Anna Bibyk on 04.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

class CountryListParser: NSObject, XMLParserDelegate {
    
    private var countryItem : [Country] = []
    private var regionItem : [Country] = []
    private var currentElement = ""
    private var currentCountry : Country?
    private var currentRegion : Country?
    private var currentCountryName : String = "" {
        didSet {
            currentCountryName = currentCountryName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler : (([Country]) -> Void)?
    
    
    func parseCountriesList(complitionHandler: (([Country]) -> Void)?) {
        self.parserCompletionHandler = complitionHandler
        
        if let path = Bundle.main.url(forResource: "regions", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        print(currentElement)
        print(attributeDict)
        print("\n..................\n")
        
        if elementName == "region" {
            guard let countryName = attributeDict["name"]?.capitalized else { return }
            let joinMapFiles = attributeDict["join_map_files"] == "yes" ? true : false
            
            currentCountry = Country(countryName: countryName, joinMapFiles: joinMapFiles, region: nil)
            
        }
        
        print(currentCountry)
        if let country = currentCountry {
            
            if currentCountry?.joinMapFiles == true {
                currentCountry?.region?.append(currentRegion!)
            } else {
                countryItem.append(currentCountry!)
            }
        }
       
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "region" {
            
            if let countryItem = currentCountry {
                currentRegion = countryItem
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(countryItem)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}

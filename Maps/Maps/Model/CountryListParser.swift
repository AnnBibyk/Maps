//
//  CountryListParser.swift
//  Maps
//
//  Created by Anna Bibyk on 04.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

class CountryListParser: NSObject, XMLParserDelegate {

    var level: Int = -1
    private var regionItem: [Region] = []
    private var parserCompletionHandler: (([Region]) -> Void)?

    func parseCountriesList(complitionHandler: (([Region]) -> Void)?) {
        self.parserCompletionHandler = complitionHandler

        if let path = Bundle.main.url(forResource: "regions", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {

        if elementName == "region" {
            level += 1
            
            guard let countryName = attributeDict["name"]?.capitalized else { return }
            let type = attributeDict["type"]
            let innerDownloadSuffix = attributeDict["innerDownloadSuffix"]
            let innerDownloadPrefix = attributeDict["innerDownloadPrefix"]
            let map = attributeDict["map"] == "yes" ? true : false
            let joinMapFiles = attributeDict["join_map_files"] == "yes" ? true : false
            let regions = [Region]()
            
            regionItem.append(Region(regionName: countryName,
                                     type: type,
                                     innerDownloadSuffix: innerDownloadSuffix,
                                     innerDownloadPrefix: innerDownloadPrefix,
                                     map: map,
                                     joinMapFiles: joinMapFiles,
                                     regions: regions))
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "region" {
            if level > 0 {
                regionItem[level - 1].regions!.append(regionItem[level])
                regionItem.removeLast()
            }
            level -= 1
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(regionItem)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}


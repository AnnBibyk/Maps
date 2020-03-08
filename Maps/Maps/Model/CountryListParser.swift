//
//  CountryListParser.swift
//  Maps
//
//  Created by Anna Bibyk on 04.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

class CountryListParser: NSObject, XMLParserDelegate {
    
    private var level: Int = -1
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
            guard let countryName = attributeDict["name"] else { return }
            let type = attributeDict["type"]
            let innerDownloadSuffix = attributeDict["inner_download_suffix"]
            var downloadSuffix = attributeDict["download_suffix"]
            let innerDownloadPrefix = attributeDict["inner_download_prefix"]
            var downloadPrefix = attributeDict["download_prefix"]
            let map = attributeDict["map"] == "yes" ? true : false
            let joinMapFiles = attributeDict["join_map_files"] == "yes" ? true : false
            let regions = [Region]()
            
            var i = level-1
            while i >= 0 && downloadSuffix == nil{
                downloadSuffix = regionItem[i].innerDownloadSuffix
                i-=1
            }
            if downloadSuffix == "$name"{
                downloadSuffix = regionItem[i+1].regionName
            }
            i = level-1
            while i >= 0 && downloadPrefix == nil{
                downloadPrefix = regionItem[i].innerDownloadPrefix
                i-=1
            }
            if downloadPrefix == "$name"{
                downloadPrefix = regionItem[i+1].regionName
            }
            
            let region = Region(regionName: countryName)
            region.type = type
            region.innerDownloadSuffix = innerDownloadSuffix
            region.downloadSuffix = downloadSuffix
            region.innerDownloadPrefix = innerDownloadPrefix
            region.downloadPrefix = downloadPrefix
            region.map = map
            region.joinMapFiles = joinMapFiles
            region.regions = regions
            
            regionItem.append(region)
            
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

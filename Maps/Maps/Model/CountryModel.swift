//
//  CountryModel.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

class Region {
    var regionName: String
    var type: String?
    var innerDownloadSuffix: String?
    var downloadSuffix: String?
    var innerDownloadPrefix: String?
    var downloadPrefix: String?
    var map: Bool?
    var joinMapFiles: Bool?
    var regions: [Region]?

    var downloaded = false
    
    init(regionName: String) {
        self.regionName = regionName
    }
}

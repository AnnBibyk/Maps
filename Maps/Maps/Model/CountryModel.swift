//
//  CountryModel.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

struct Region {
    var regionName: String
    var type: String?
    var innerDownloadSuffix: String?
    var innerDownloadPrefix: String?
    var map: Bool?
    var joinMapFiles: Bool?
    var regions: [Region]?
    
}

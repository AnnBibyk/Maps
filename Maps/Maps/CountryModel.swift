//
//  CountryModel.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

struct Country {
    var countryName: String
    var joinMapFiles: Bool?
    var region: [Country]?
    
}
struct Region {
    var regionName: String
}

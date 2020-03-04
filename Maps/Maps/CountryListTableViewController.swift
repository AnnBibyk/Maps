//
//  CountryListTableViewController.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class CountryListTableViewController: UITableViewController {

    var countries: [Country] = []
    var elementName: String = String()
    var countryName = String()
    var totalDeviceSpace : String = {
        var totalSpace = String()
        totalSpace = UIDevice.current.totalDiskSpaceInGB
        return totalSpace
    }()
    
    var freeDeviceSpace : String = {
        let freeSpace = UIDevice.current.freeDiskSpaceInGB
        return freeSpace
    }()
    
    var usedDeviceSpace : String = {
        let usedSpace = UIDevice.current.usedDiskSpaceInGB
        return usedSpace
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    private func fetchData() {
        let coutryParser = CountryListParser()
        
        coutryParser.parseCountriesList { (countryItems) in
            self.countries = countryItems
            self.countries.sort() {
                $0.countryName < $1.countryName
            }
            print(self.countries)
            print("!!!")
        }
    }

    // MARK: - Table view configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return countries.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let totalMemory = totalDeviceSpace.floatValue
            let usedMemory = usedDeviceSpace.floatValue
            let cell = tableView.dequeueReusableCell(withIdentifier: "deviceMemoryCell", for: indexPath) as! DeviceMemoryCell
            cell.memoryCapacityLabel.text = "Free \(freeDeviceSpace)"
            cell.deviceMemoryBar.setProgress(0.0, animated: false)
            cell.deviceMemoryBar.layer.cornerRadius = 8
            cell.deviceMemoryBar.layer.sublayers![1].cornerRadius = 8
            cell.deviceMemoryBar.subviews[1].clipsToBounds = true
            cell.deviceMemoryBar.clipsToBounds = true
            cell.deviceMemoryBar.progress = usedMemory / totalMemory

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryListCell
            cell.countryNameLabel.text = countries[indexPath.row].countryName
            cell.downloadingProgress.isHidden = true
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


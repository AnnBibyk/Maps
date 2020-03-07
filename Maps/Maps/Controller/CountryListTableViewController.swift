//
//  CountryListTableViewController.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class CountryListTableViewController: UITableViewController {
    
    var countries: [Region] = []
    var selectedRow = Int()
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
    
    //var downloaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
    }
    
    private func fetchData() {
        let coutryParser = CountryListParser()
        
        coutryParser.parseCountriesList { (countryItems) in
            self.countries = countryItems[0].regions!
            self.countries.sort() {
                $0.regionName < $1.regionName
            }
        }
    }
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "deviceMemoryCell", for: indexPath) as! DeviceMemoryCell
            cell.configure(totalMemory: totalDeviceSpace, usedMemory: usedDeviceSpace, freeDeviceSpace: freeDeviceSpace)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryListCell
            cell.configure(region: countries[indexPath.row])
            
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        
        self.performSegue(withIdentifier: "goToRegions", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegions" {
            if let vc = segue.destination as? CountryRegionsTableViewController {
                vc.regions = countries[selectedRow].regions!
                vc.country = countries[selectedRow].regionName
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 42
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 16, width: 320, height: 20)
        myLabel.font = UIFont.systemFont(ofSize: 13)
        myLabel.textColor = .gray
        myLabel.text = "EUROPE"
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
}

extension CountryListTableViewController: CountryListCellDelegate {
    
    func downloadButtonPressed(_ cell: CountryListCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            countries[indexPath.row].downloaded = false
            selectedRow = indexPath.row
            let downloadMap = DownloadMap(vc: self, region: countries[indexPath.row], indexPath: indexPath)
            
            downloadMap.startDownloading()
    
        }
        
    }
}



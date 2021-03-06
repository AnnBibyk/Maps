//
//  CountryListTableViewController.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class CountryListTableViewController: UITableViewController {
    
    private var countries: [Region] = []
    private var queue = OperationQueue()
    private var selectedCountry : IndexPath?
    private var totalDeviceSpace : String = {
        var totalSpace = String()
        totalSpace = UIDevice.current.totalDiskSpaceInGB
        return totalSpace
    }()
    
    private var freeDeviceSpace : String = {
        let freeSpace = UIDevice.current.freeDiskSpaceInGB
        return freeSpace
    }()
    
    private var usedDeviceSpace : String = {
        let usedSpace = UIDevice.current.usedDiskSpaceInGB
        return usedSpace
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 1
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        freeDeviceSpace = UIDevice.current.freeDiskSpaceInGB
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    // MARK: - Data Fetching
    
    private func fetchData() {
        let coutryParser = CountryListParser()
        
        coutryParser.parseCountriesList { (countryItems) in
            self.countries = countryItems[0].regions!
            self.countries.sort() {
                $0.regionName < $1.regionName
            }
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
    
    // MARK: - Moving to the second View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = indexPath
        
        self.performSegue(withIdentifier: "goToRegions", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegions" {
            if let vc = segue.destination as? CountryRegionsTableViewController {
                vc.regions = countries[self.selectedCountry!.row].regions!
            }
        }
    }
    
    // MARK: - Table View Section Configuration
    
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
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if countries[indexPath.row].regions?.count == 0 {
            return nil
        }
        return indexPath
    }
}

// MARK: - Download Button Pressed

extension CountryListTableViewController: CountryListCellDelegate {
    
    func downloadButtonPressed(_ cell: CountryListCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let downloadMap = DownloadMap(vc: self, region: countries[indexPath.row], queue: queue, indexPath: indexPath)
            cell.downloadingProgress.isHidden = false
            cell.downloadButton.isEnabled = false
            downloadMap.delegate = self
            downloadMap.startDownloading()
        }
    }
}

// MARK: - Update Cell View

extension CountryListTableViewController : UpdateCellViewDelegate {
    func updateCellView(downloaded: Bool, indexPath: IndexPath) {
        countries[indexPath.row].downloaded = downloaded
        freeDeviceSpace = UIDevice.current.freeDiskSpaceInGB
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

//
//  DownloadMap.swift
//  Maps
//
//  Created by Anna Bibyk on 06.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation
import UIKit

class DownloadMap  {
    
    var indexPath: IndexPath?
    var region : Region?
    var vc : UITableViewController?
    let baseURL = "http://download.osmand.net/download.php?standard=yes&file="
    let queue = OperationQueue()
    
    init(vc : UITableViewController, region : Region, indexPath : IndexPath) {
        self.vc = vc
        self.region = region
        self.indexPath = indexPath
        
        queue.maxConcurrentOperationCount = 1
    }
    
    func getDownloadName(region: Region)->String{
        if region.downloadPrefix != nil && region.downloadSuffix != nil{
            return "\(region.downloadPrefix!.capitalizedFirstLetter)_\(region.regionName)_\(region.downloadSuffix!)_2.obf.zip"
        }
        if region.downloadSuffix != nil{
            return "\(region.regionName.capitalizedFirstLetter)_\(region.downloadSuffix!)_2.obf.zip"
        }
        if region.downloadPrefix != nil {
            return "\(region.downloadPrefix!.capitalizedFirstLetter)_\(region.regionName)_2.obf.zip"
        }
        return ""
    }
    
    func startDownloading() {
        let url = URL(string: "\(baseURL)\(getDownloadName(region: region!))")
        
        let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: url!, completionHandler: { (localURL, response, error) in
            if error != nil {
                print("Downloading Error \(String(describing: error))")
                self.vc!.alertCall(message: "The map could't been downloaded. Error: \(String(describing: error))")
            }
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200 {
                    print("Downloading successfully finished")
                    self.region?.downloaded = true
                    DispatchQueue.main.async {
                        self.vc?.reloadCellData(self.indexPath!)
                    }
                } else {
                    print("Downloading error -> \(httpResponse.statusCode.description)")
                    DispatchQueue.main.async {
                        self.vc?.alertCall(message: "The map could't be downloaded. Error: \(httpResponse.statusCode.description)")
                    }
                }
            }
        })
        operation.delegate = self
        queue.addOperation(operation)
    }
}

extension DownloadMap : DownloadOperatorDelegate {
    
    func updateProgress(progress: Float, wait: Bool) {
        DispatchQueue.main.async {
            if let regionCell = self.vc!.tableView.cellForRow(at: IndexPath(row: self.indexPath!.row, section: self.indexPath!.section)) as? CountryListCell {
                regionCell.updateDisplay(progress:progress)
            }
        }
    }
}

//
//  DownloadMap.swift
//  Maps
//
//  Created by Anna Bibyk on 06.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateCellViewDelegate {
    func updateCellView(downloaded: Bool, indexPath: IndexPath)
}

class DownloadMap  {
    
    var indexPath: IndexPath?
    var region : Region?
    var vc : UITableViewController?
    let baseURL = "http://download.osmand.net/download.php?standard=yes&file="
    let queue: OperationQueue?
    var delegate : UpdateCellViewDelegate?
    
    init(vc : UITableViewController, region : Region,queue:OperationQueue, indexPath : IndexPath) {
        self.vc = vc
        self.region = region
        self.indexPath = indexPath
        self.queue = queue
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
        guard let url = URL(string: "\(baseURL)\(getDownloadName(region: region!))") else { return }
        
        let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error) in
            if error != nil {
                print("Downloading Error \(String(describing: error))")
                self.vc?.alertCall(message: "The map could't been downloaded. Error: \(String(describing: error))")
            }
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200 {
                    print("Downloading successfully finished")
                    DispatchQueue.main.async {
                        self.delegate?.updateCellView(downloaded: true, indexPath: self.indexPath!)
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
        queue?.addOperation(operation)
    }
}

// MARK: - Download Process Updating

extension DownloadMap : DownloadOperatorDelegate {
    
    func updateProgress(progress: Float) {
        DispatchQueue.main.async {
            if let regionCell = self.vc?.tableView.cellForRow(at: IndexPath(row: self.indexPath!.row, section: self.indexPath!.section)) as? CountryListCell {
                regionCell.updateDisplay(progress:progress)
            }
        }
    }
}

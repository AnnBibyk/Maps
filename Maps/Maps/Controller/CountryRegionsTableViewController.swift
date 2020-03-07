//
//  CountryRegionsTableViewController.swift
//  Maps
//
//  Created by Anna Bibyk on 05.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class CountryRegionsTableViewController: UITableViewController {

    var regions = [Region]()
    var queue = OperationQueue()
    var country = String()
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue.maxConcurrentOperationCount = 1
        self.navigationController?.navigationBar.tintColor = .white
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryListCell
        cell.configure(region: regions[indexPath.row])
        
        cell.delegate = self
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 16, width: 320, height: 20)
        myLabel.font = UIFont.systemFont(ofSize: 13)
        myLabel.textColor = .gray
        myLabel.text = "REGIONS"

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if regions[indexPath.row].regions?.count == 0 {
            return nil
        }
        return indexPath
    }
}

// MARK: - DownloadButtonPressed

extension CountryRegionsTableViewController: CountryListCellDelegate {
    
    func downloadButtonPressed(_ cell: CountryListCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            let downloadMap = DownloadMap(vc: self, region: regions[indexPath.row], queue: queue, indexPath: indexPath)
            cell.downloadingProgress.isHidden = false
            cell.downloadButton.isEnabled = false
            downloadMap.delegate = self
            downloadMap.startDownloading()
        }
    }
}

// MARK: - UpdateCellView

extension CountryRegionsTableViewController : UpdateCellViewDelegate {
    func updateCellView(downloaded: Bool, indexPath: IndexPath) {
        regions[indexPath.row].downloaded = downloaded
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

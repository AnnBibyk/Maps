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
    var country = String()
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
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

extension CountryRegionsTableViewController: CountryListCellDelegate {
    
    func downloadButtonPressed(_ cell: CountryListCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            regions[indexPath.row].downloaded = false
            selectedRow = indexPath.row
            let downloadMap = DownloadMap(vc: self, region: regions[indexPath.row], indexPath: indexPath)
            downloadMap.delegate = self
            downloadMap.startDownloading()
    
        }
        
    }
}

extension CountryRegionsTableViewController : UpdateCellViewDelegate {
    func updateCellView(downloaded: Bool, indexPath: IndexPath) {
        regions[indexPath.row].downloaded = downloaded
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

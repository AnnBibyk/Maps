//
//  CountryListCell.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class CountryListCell: UITableViewCell {

    @IBOutlet weak var mapIconImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadingProgress: UIProgressView!
    
    let queue = OperationQueue()
    let baseURL = "http://download.osmand.net/download.php?standard=yes"
    var urls = [URL]()
//        URL(string: "http://download.osmand.net/download.php?standard=yes&file=Denmark_europe_2.obf.zip")!,
//        URL(string: "http://download.osmand.net/download.php?standard=yes&file=Germany_berlin_europe_2.obf.zip")!,
//        URL(string: "http://download.osmand.net/download.php?standard=yes&file=France_corse_europe_2.obf.zip")!,
//    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(region: Region, downloaded: Bool) { //, download: Download?) {
        
        queue.maxConcurrentOperationCount = 1
        
        countryNameLabel.text = region.regionName
        if region.regions?.count != 0 {
            downloadButton.setImage(UIImage(named: "ic_custom_chevron"), for: .normal)
            downloadButton.isUserInteractionEnabled = false
        } else {
            downloadButton.setImage(UIImage(named: "ic_custom_dowload"), for: .normal)
        }
        downloadingProgress.isHidden = true
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        print("Download")
        downloadingProgress.isHidden = false
        urls.append(URL(string: "http://download.osmand.net/download.php?standard=yes&file=Denmark_europe_2.obf.zip")!)
        
        for url in urls {
            let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error) in
                //print(response)
                print("finished downloading \(url.absoluteString)")
            })
            
            queue.addOperation(operation)
            
        }
        
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
      downloadingProgress.progress = progress
//      progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
    
}

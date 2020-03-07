//
//  CountryListCell.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

protocol CountryListCellDelegate {
    func downloadButtonPressed(_ cell: CountryListCell)
}

class CountryListCell: UITableViewCell {
    
    @IBOutlet weak var mapIconImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadingProgress: UIProgressView!
    
    var delegate: CountryListCellDelegate?
    var downloadOper :DownloadOperation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(region: Region) {

        countryNameLabel.text = region.regionName.capitalized
        if region.regions?.count != 0 {
            downloadButton.setImage(UIImage(named: "ic_custom_chevron"), for: .normal)
            downloadButton.isUserInteractionEnabled = false
        } else {
            downloadButton.setImage(UIImage(named: "ic_custom_dowload"), for: .normal)
            //self.isUserInteractionEnabled = false
        }
        downloadingProgress.isHidden = true
        mapIconImage.image = mapIconImage.image?.withRenderingMode(.alwaysTemplate)
        mapIconImage.tintColor = region.downloaded ? .systemGreen : .lightGray
    }
    
    @IBAction func downloadButtonPressed(_ sender: AnyObject) {
        
        delegate?.downloadButtonPressed(self)
        print("Download")
    }
    
    func updateDisplay(progress: Float) {
        print(progress)
        downloadingProgress.isHidden = false
        downloadingProgress.progress = progress
        downloadButton.isUserInteractionEnabled = true
        
    }
    
}

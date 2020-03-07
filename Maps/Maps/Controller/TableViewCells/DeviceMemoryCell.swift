//
//  DeviceMemoryCell.swift
//  Maps
//
//  Created by Anna Bibyk on 03.03.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class DeviceMemoryCell: UITableViewCell {

    @IBOutlet weak var memoryCapacityLabel: UILabel!
    @IBOutlet weak var deviceMemoryBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(totalMemory: String, usedMemory: String, freeDeviceSpace: String) {
        
        let totalMemory = totalMemory.floatValue
        let usedMemory = usedMemory.floatValue
        
        memoryCapacityLabel.text = "Free \(freeDeviceSpace)"
        deviceMemoryBar.setProgress(0.0, animated: false)
        deviceMemoryBar.layer.cornerRadius = 8
        deviceMemoryBar.layer.sublayers![1].cornerRadius = 8
        deviceMemoryBar.subviews[1].clipsToBounds = true
        deviceMemoryBar.clipsToBounds = true
        deviceMemoryBar.progress = usedMemory / totalMemory
        
    }

}

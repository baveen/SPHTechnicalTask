//
//  QuarterTableViewCell.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

class QuarterTableViewCell: UITableViewCell {

    @IBOutlet weak var lowVolumeIndicator: UIImageView!
    @IBOutlet weak var quarterLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateQuatersCell(record: Record, parentRecord: AnnualRecord) {
        let quarter = record.quarter?.components(separatedBy: "-").last
        self.quarterLabel.text = "Quarter: \(quarter!)"
        if let volume = record.dataVolume {
            self.volumeLabel.text = "Used Data: \(volume)"
            if volume == parentRecord.lowVolumeValue {
                self.lowVolumeIndicator.isHidden = false
            } else {
                self.lowVolumeIndicator.isHidden = true
            }
        }
    }

}

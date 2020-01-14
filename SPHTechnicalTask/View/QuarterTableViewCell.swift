//
//  QuarterTableViewCell.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

protocol QuarterTableViewCellDelegate: class {
    func lowVolumeButtonClicked()
}

class QuarterTableViewCell: UITableViewCell {
    static let cellHeight: CGFloat = 80
    static let recordCellIdentifier = "QuarterCellIdentifier"
    
    @IBOutlet weak var lowVolumeIndicatorButton: UIButton!
    @IBOutlet weak var quarterLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    weak var delegate: QuarterTableViewCellDelegate!
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
                self.lowVolumeIndicatorButton.isHidden = false
            } else {
                self.lowVolumeIndicatorButton.isHidden = true
            }
        }
    }
    
    @IBAction func lowVolumeIndicatorClicked(_ sender: Any) {
        self.delegate.lowVolumeButtonClicked()
    }
    
}

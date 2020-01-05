//
//  AnnualRecordCell.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

protocol RecordCellDelegate: class {
    func reloadQuartersTableView(_ annualRecord: AnnualRecord)
}

class AnnualRecordCell: UICollectionViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var totalVolumeLabel: UILabel!
    @IBOutlet weak var quartersTableView: UITableView!
    weak var delegae: RecordCellDelegate!
    var currentLoadingIndex = 0
    
    func updateCell(object: AnnualRecord) {
        self.yearLabel.text = "YEAR: \(object.year)"
        let formattedString = String(format: "%.8f", object.totalVolume)
        self.totalVolumeLabel.text = "Total Usage: \(formattedString)"
    }
    
    func setTableViewDataSourceDelegate(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate, record: AnnualRecord) {
        quartersTableView.delegate = dataSourceDelegate
        quartersTableView.dataSource = dataSourceDelegate
        quartersTableView.tag = currentLoadingIndex
        self.delegae.reloadQuartersTableView(record)
        quartersTableView.reloadData()
    }
    
}



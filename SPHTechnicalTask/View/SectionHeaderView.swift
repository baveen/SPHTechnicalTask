//
//  SectionHeaderView.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/14/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "sectionHeaderView"
    var yearLabel: UILabel!
    var usageLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func updateLabels(item: AnnualRecord) {
        self.yearLabel.text = "YEAR: \(item.year)"
        let str = String(format: "%.8f", item.totalVolume)
        self.usageLabel.text = "Total Usage: \(str)"
    }
    
    func configureViews() {
        yearLabel = UILabel()
        usageLabel = UILabel()
        self.addSubview(yearLabel)
        self.addSubview(usageLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        usageLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        yearLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        yearLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        yearLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier:0.3).isActive = true
        usageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        usageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        usageLabel.leadingAnchor.constraint(equalTo: self.yearLabel.trailingAnchor, constant: 8).isActive = true
        usageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:8).isActive = true

    }

}

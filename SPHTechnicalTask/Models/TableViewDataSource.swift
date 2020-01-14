//
//  TableViewDataSource.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/14/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var annualRecords: [AnnualRecord]! = [AnnualRecord]()
    var owner: UIViewController!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.annualRecords.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.annualRecords[section].quarters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuarterTableViewCell.recordCellIdentifier, for: indexPath) as! QuarterTableViewCell
        cell.delegate = owner as? QuarterTableViewCellDelegate
        let annualRecord = self.annualRecords[indexPath.section]
        let cellRecord = annualRecord.quarters[indexPath.row]
        cell.updateQuatersCell(record: cellRecord, parentRecord: annualRecord)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuarterTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as? SectionHeaderView else {
            return nil
        }
        view.updateLabels(item: self.annualRecords[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderView.headerHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let vc = owner as! ViewController
        if let totalRecords = vc.viewModel.numberOfRecords, totalRecords > self.annualRecords.count {
            vc.loadData()
        }
    }
    
}

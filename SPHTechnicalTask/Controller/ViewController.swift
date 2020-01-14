//
//  ViewController.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var activityIndicator: UIActivityIndicatorView!
    let recordCellIdentifier = "QuarterCellIdentifier"
    var annualRecords: [AnnualRecord] = []

    @IBOutlet weak var dataRecordCollectionView: UICollectionView!
     let viewModel = UsageViewModel(apiClient: APIClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Data Usage from 2008 - 2018"
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        self.tableView.backgroundView = activityIndicatorView
        self.tableView.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.tableView.separatorInsetReference = .fromAutomaticInsets
        self.activityIndicator = activityIndicatorView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        loadData()
    }
       
    func showAlert(title: String = "Error!", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        if isReachingEnd {
            self.loadData()
        }
    }
    
    func loadData() {
        if viewModel.numberOfRecords == nil {
            return
        }
        self.showActivityIndicator()
        DispatchQueue.global(qos: .background).async {
            self.viewModel.getDataUsage() { (response, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.hideActivityIndicator()
                        self.showAlert(message: error!)
                    } else if let data = response, data.count > 0 {
                        self.annualRecords = data
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                    } else {
                        self.hideActivityIndicator()
                    }
                }
            }
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.isHidden = true
        self.tableView.isHidden = false
        activityIndicator.stopAnimating()
    }

}

extension ViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.annualRecords.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.annualRecords[section].quarters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recordCellIdentifier, for: indexPath) as! QuarterTableViewCell
        cell.delegate = self
        let annualRecord = self.annualRecords[indexPath.section]
        let cellRecord = annualRecord.quarters[indexPath.row]
        cell.updateQuatersCell(record: cellRecord, parentRecord: annualRecord)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuarterTableViewCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as? SectionHeaderView else {
            return nil
        }
        view.updateLabels(item: self.annualRecords[section])
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SectionHeaderView.headerHeight
    }
        
}


extension ViewController: QuarterTableViewCellDelegate {
    func lowVolumeButtonClicked() {
        self.showAlert(title: "Lowest Data Consumption", message: "This quarter has the lowest data consumption for the year.")
    }
}

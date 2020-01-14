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
    var dataSource: TableViewDataSource!

    @IBOutlet weak var dataRecordCollectionView: UICollectionView!
     let viewModel = UsageViewModel(apiClient: APIClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Data Usage from 2008 - 2018"
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        self.tableView.backgroundView = activityIndicatorView
        self.activityIndicator = activityIndicatorView
        dataSource = TableViewDataSource()
        dataSource.owner = self
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        loadData()
    }
       
    func showAlert(title: String = "Error!", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.loadData()
        }))
        self.present(alert, animated: true, completion: nil)
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
                        self.dataSource.annualRecords = data
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
        activityIndicator.stopAnimating()
    }

}

extension ViewController: QuarterTableViewCellDelegate {
    func lowVolumeButtonClicked() {
        self.showAlert(title: "Lowest Data Consumption", message: "This quarter has the lowest data consumption for the year.")
    }
}

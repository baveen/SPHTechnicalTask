//
//  ViewController.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let annualCellIdentifier = "AnnualRecordCellIdentifier"
    let recordCellIdentifier = "QuarterCellIdentifier"
    var annualRecords: [AnnualRecord] = []
    var currentlyLoadedAnnualRecord: AnnualRecord!
    let tableViewCellHeight: CGFloat = 45.0

    @IBOutlet weak var dataRecordCollectionView: UICollectionView!
     let viewModel = UsageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Data Usage from 2008 - 2018"
        
        setupCollectionView()
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            UsageViewModel().getDataUsage(offset: 100) { (response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.showAlert(message: error!)
                    }
                } else {
                  if let data = response {
                      self.annualRecords = data
                      DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                          self.dataRecordCollectionView.reloadData()
                      }
                  }
                }
            }
        }
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        dataRecordCollectionView.collectionViewLayout = flowLayout
        
        dataRecordCollectionView.dataSource = self
        dataRecordCollectionView.delegate = self
        dataRecordCollectionView.backgroundColor = .lightGray
    }
               
    func showAlert(title: String = "Error!", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.annualRecords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: annualCellIdentifier, for: indexPath) as! AnnualRecordCell
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15.0
        cell.currentLoadingIndex = indexPath.item
        let cellObject = self.annualRecords[indexPath.item]
        cell.delegae = self
        cell.updateCell(object: cellObject)
        cell.quartersTableView.isScrollEnabled = false
        cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, record: cellObject)
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 20, height: 230)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension ViewController: RecordCellDelegate {
    func reloadQuartersTableView(_ annualRecord: AnnualRecord) {
        currentlyLoadedAnnualRecord = annualRecord
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentlyLoadedAnnualRecord.quarters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recordCellIdentifier, for: indexPath) as! QuarterTableViewCell
        let cellRecord = self.currentlyLoadedAnnualRecord.quarters[indexPath.row]
        cell.updateQuatersCell(record: cellRecord, parentRecord: self.currentlyLoadedAnnualRecord)
        return cell
    }
}



//
//  TableViewDataSourceTests.swift
//  SPHTechnicalTaskTests
//
//  Created by Baveendran Nagendran on 1/14/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

@testable import SPHTechnicalTask
import XCTest

class TableViewDataSourceTests: XCTestCase {
    let annrecords = MockAPIClient().getAnnualRecords()
    var tblView: UITableView!
    var controller: ViewController!
    var dataSource: TableViewDataSource!
    
    override func setUp() {
        controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataUsageController") as? ViewController
        _ = controller.view
        dataSource = TableViewDataSource()
        dataSource.annualRecords = annrecords
        tblView = controller.tableView
        tblView.dataSource = dataSource
        tblView.delegate = dataSource
    }

    override func tearDown() {
        tblView = nil
        controller = nil
        super.tearDown()
    }
    
    func testTableViewSections() {
        let sections = tblView.numberOfSections
        XCTAssertEqual(sections, 2)
        XCTAssertEqual(tblView.numberOfRows(inSection: 1), 3)
    }
    
    func testCellRowAtIndex() {
        tblView.reloadData()
        let cellQueried = tblView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cellQueried is QuarterTableViewCell)
        let cell = cellQueried as! QuarterTableViewCell
        XCTAssertNotNil(cell.quarterLabel)
        XCTAssertNotNil(cell.volumeLabel)
    }

}

//
//  ViewControllerTests.swift
//  SPHTechnicalTaskTests
//
//  Created by Baveendran Nagendran on 1/14/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

@testable import SPHTechnicalTask
import XCTest

class ViewControllerTests: XCTestCase {
    var controller: ViewController!
    
    override func setUp() {
        controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataUsageController") as? ViewController
        _ = controller.view
    }

    override func tearDown() {
        controller = nil
        super.tearDown()
    }
    
    func testMovieViewControllerNotNil(){
        XCTAssertNotNil(controller)
    }
       
    func testMovieViewControllerTableViewNotNil(){
        XCTAssertNotNil(controller.tableView)
    }

}
   

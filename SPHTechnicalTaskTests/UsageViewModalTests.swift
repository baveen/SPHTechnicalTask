//
//  UsageViewModalTests.swift
//  SPHTechnicalTaskTests
//
//  Created by Baveendran Nagendran on 1/12/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

@testable import SPHTechnicalTask
import XCTest

class UsageViewModalTests: XCTestCase {
    var viewModel: UsageViewModel!

    override func setUp() {
        super.setUp()
        let mockclient = MockAPIClient()
        viewModel = UsageViewModel(apiClient: mockclient)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testGetUsedData() {
        let expectation = self.expectation(description: "Data usage View Model")
        viewModel.getDataUsage { (resp, errorString) in
             XCTAssertNil(errorString)
              guard let json = resp else {
                 XCTFail()
                 return
              }
            XCTAssertNotNil(json)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    func testGetAnnualRecordArray() {
        let resp = (viewModel.client as! MockAPIClient).mockResponse()
        XCTAssertNotNil(resp)
    }
            
}



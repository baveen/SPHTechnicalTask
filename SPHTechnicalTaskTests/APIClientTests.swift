//
//  APIClientTests.swift
//  SPHTechnicalTaskTests
//
//  Created by Baveendran Nagendran on 1/12/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

@testable import SPHTechnicalTask
import XCTest

class APIClientTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAPIClientResponse() {
        let expectation = self.expectation(description: "Data usage response")
        MockAPIClient().fetchUsedMobileData(nextUrl: "") { (response, errorString) in
            XCTAssertNil(errorString)
            guard let json = response else {
                XCTFail()
                return
            }
            XCTAssertNotNil(json)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }

}

class MockAPIClient {
    func mockResponse() -> DataUsageApiResponse? {
        if let path = Bundle.main.path(forResource: "MockResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try JSONDecoder().decode(DataUsageApiResponse.self, from: data)
            } catch {
                print(NetworkResponse.unableToDecode.rawValue)
            }
        }
        return nil
    }
}

extension MockAPIClient: APIClientProtocol {
    func fetchUsedMobileData(nextUrl: String, callBack: @escaping ApiResponseCallBack) {
        if let resp = self.mockResponse() {
            callBack(resp, nil)
        } else {
            callBack(nil, "Error")
        }
    }
}





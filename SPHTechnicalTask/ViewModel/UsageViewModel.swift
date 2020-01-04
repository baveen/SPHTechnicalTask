//
//  UsageViewModel.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import Foundation

class UsageViewModel {
    func getDataUsage(offset: Int, callBack:@escaping ApiResponseCallBack) {
        APIClient.fetchUsedMobileData(pageOffset: offset) { (response, error) in
            if let success = response?.success {
                if success {
                    callBack(response,nil)
                } else {
                    callBack(nil,error)
                }
            }
        }
    }
}

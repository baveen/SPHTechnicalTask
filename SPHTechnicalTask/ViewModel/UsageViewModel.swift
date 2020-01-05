//
//  UsageViewModel.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import Foundation

class UsageViewModel {
    let searchPath = "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
    var nextUrl: String!
    let pageLimit = 100
    
    init() {
        nextUrl = searchPath+"&limit=\(pageLimit)"
    }
    
    func getDataUsage(offset: Int, callBack:@escaping (Array<AnnualRecord>?, _ error: String?) -> Void) {
        APIClient.shared.fetchUsedMobileData(nextUrl: nextUrl) { (response, error) in
            if let success = response?.success, success {
                let downloadedRecords = self.getAnnualRecordsArray(response: response)
                self.nextUrl = response?.result?.links?.next
                callBack(downloadedRecords,nil)
            } else {
                callBack(nil,error)
            }
        }
    }
    
    func getAnnualRecordsArray(response: DataUsageApiResponse?) -> [AnnualRecord] {
        var dataArray: [AnnualRecord] = []
        if let data = response {
            let array = data.result?.records ?? [Record]()
            let recordsByYear = Dictionary(grouping: array, by: {$0.quarter!.components(separatedBy: "-").first})
            let sortedKeys =  recordsByYear.keys.sorted{ $0! < $1!}
            sortedKeys.forEach { (key) in
                let keyIntVal = Int(key!)!
                if keyIntVal >= 2008, keyIntVal <= 2018 {
                    let annualRecord = AnnualRecord(records:recordsByYear[key]!, yearObj: key!)
                    dataArray.append(annualRecord)
                }
            }
        }
        return dataArray
    }
        
}
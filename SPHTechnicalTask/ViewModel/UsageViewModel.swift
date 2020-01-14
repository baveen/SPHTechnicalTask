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
    var numberOfRecords: Int? = 0
    let pageLimit = 30
    var client: APIClientProtocol!
    var annualRecordsDictionary = [String: AnnualRecord]()
    init(apiClient: APIClientProtocol) {
        nextUrl = searchPath+"&limit=\(pageLimit)"
        client = apiClient
    }
    
    func getDataUsage(callBack:@escaping ([AnnualRecord]?, _ error: String?) -> Void) {
        client.fetchUsedMobileData(nextUrl: nextUrl) { (response, error) in
            if let success = response?.success, success {
                let downloadedRecords = self.getAnnualRecordsArray(response: response)
                self.nextUrl = response?.result?.links?.next
                self.numberOfRecords = response?.result?.total
                callBack(downloadedRecords,nil)
            } else {
                callBack(nil,error)
            }
        }
    }
    
    func getAnnualRecordsArray(response: DataUsageApiResponse?) -> [AnnualRecord] {
        if let data = response {
            let array = data.result?.records ?? [Record]()
            let recordsByYear = Dictionary(grouping: array, by: {$0.quarter!.components(separatedBy: "-").first})
            let sortedKeys =  recordsByYear.keys.sorted{ $0! < $1!}
            sortedKeys.forEach { (key) in
                let annualRecord = AnnualRecord(records:recordsByYear[key]!, yearObj: key!)
                if annualRecordsDictionary[key!] == nil {
                    annualRecordsDictionary.updateValue(annualRecord, forKey: key!)
                } else if annualRecordsDictionary[key!] != nil, let qrts = annualRecordsDictionary[key!]?.quarters, qrts.count < 4  {
                    let existingObject  = annualRecordsDictionary[key!]
                    var newQuartersArray = existingObject?.quarters
                    newQuartersArray?.append(contentsOf: annualRecord.quarters)
                    let newAnnualRecord = AnnualRecord(records: newQuartersArray!, yearObj: key!)
                    annualRecordsDictionary.updateValue(newAnnualRecord, forKey: key!)
                }
            }
        }
        return processDataArray()
    }
    
    func processDataArray() -> [AnnualRecord] {
        var dataArray: [AnnualRecord] = []
        let sortedKeys =  annualRecordsDictionary.keys.sorted{ $0 < $1}
        sortedKeys.forEach { (key) in
            let keyIntVal = Int(key)!
            if keyIntVal >= 2008, keyIntVal <= 2018 {
                let annualRecord = annualRecordsDictionary[key]!
                dataArray.append(annualRecord)
            }
        }
        return dataArray
    }
        
}

//
//  AnnualRecord.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/5/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import Foundation

struct AnnualRecord: Sequence, IteratorProtocol {
    var year: String = ""
    var quarters: [Record] = []
    var index = 0
    var totalVolume: Double {
        return self.quarters.map({Double($0.dataVolume ?? "0") ?? 0}).reduce(0, +)
    }
    
    var lowVolumeValue: String? {
        return  quarters.min()?.dataVolume
    }
    
    init(records: [Record], yearObj: String) {
        self.year = yearObj
        self.quarters = records
    }
    
    mutating func next() -> Record? {
        index += 1
        return quarters[index]
    }
}

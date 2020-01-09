//
//  DataUsageResponse.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import Foundation

// MARK: - DataUsageApiResponse
struct DataUsageApiResponse: Codable {
    let help: String!
    let success: Bool!
    let result: UsageResult?
}

// MARK: - UsageResult
struct UsageResult: Codable {
    let resourceID: String?
    let fields: [Field]?
    let records: [Record]?
    let links: Links?
    let limit: Int?
    let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields = "fields"
        case records = "records"
        case links = "_links"
        case limit = "limit"
        case total = "total"
    }
       
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceID = try values.decodeIfPresent(String.self, forKey: .resourceID)
        fields = try values.decodeIfPresent([Field].self, forKey: .fields)
        records = try values.decodeIfPresent([Record].self, forKey: .records)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
}

// MARK: - Field
struct Field: Codable {
    let type: String?
    let id: String?
}

// MARK: - Record
struct Record: Codable, Comparable {
    static func < (lhs: Record, rhs: Record) -> Bool {
        if let volume1 = lhs.dataVolume, let value1 = Double(volume1), let volume2 = rhs.dataVolume, let value2 = Double(volume2) {
            return value1 < value2
        }
        return false
    }
    
    let dataVolume : String?
    let quarter : String?
    let id : Int?
    
    enum CodingKeys: String, CodingKey {
        case dataVolume = "volume_of_mobile_data"
        case quarter = "quarter"
        case id = "_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dataVolume = try values.decodeIfPresent(String.self, forKey: .dataVolume)
        quarter = try values.decodeIfPresent(String.self, forKey: .quarter)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }
}

// MARK: - Links
struct Links: Codable {
    let start: String?
    let next: String?
}

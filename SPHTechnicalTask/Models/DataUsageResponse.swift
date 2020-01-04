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
}

// MARK: - Field
struct Field: Codable {
    let type: String?
    let id: String?
}

// MARK: - Record
struct Record: Codable {
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

//
//  CompareModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation
import OptionallyDecodable


// MARK: - CompareModel
struct CompareModel: Codable {
    var statusCode: Int
    var status: String
    var message: String
    var data: CompareData

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
struct CompareData: Codable, Equatable {
    var result: String
    var baseCode: String
    var targetCodes: [String]
    var conversionRates: [String:Double]

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case baseCode = "base_code"
        case targetCodes = "target_codes"
        case conversionRates = "conversion_rates"
    }
}

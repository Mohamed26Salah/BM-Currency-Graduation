//
//  ConvertModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation
import OptionallyDecodable

struct ConvertModel: Codable {
    var statusCode: Int
    var status: String
    var message: String
    var data: ConvertRate

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
struct ConvertRate: Codable, Equatable {
    var baseCode: String
    var targetCode: String
    var conversionRate: Double
    var conversionResult: Double

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
        case conversionResult = "conversion_result"
    }
}

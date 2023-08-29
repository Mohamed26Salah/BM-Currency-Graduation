//
//  ConvertionRate.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 28/08/2023.
//

import Foundation
import OptionallyDecodable 

// MARK: - ConverstionRate
struct Converstion: Codable {
    var statusCode: Int
    var status: String
    var message: String
    var data: ConverstionRate

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

// MARK: - DataClass
struct ConverstionRate: Codable {
    var baseCode: String
    var targetCode: String
    var conversionRate: Double

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
    }
}

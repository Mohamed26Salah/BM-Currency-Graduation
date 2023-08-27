//
//  ConvertionRate.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 28/08/2023.
//

import Foundation
import OptionallyDecodable // https://github.com/idrougge/OptionallyDecodable

// MARK: - ConverstionRate
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

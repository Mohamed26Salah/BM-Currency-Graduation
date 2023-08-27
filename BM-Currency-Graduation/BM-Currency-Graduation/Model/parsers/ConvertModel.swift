//
//  ConvertModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation
import OptionallyDecodable

// MARK: - DecodeScene
struct ConvertModel: Codable {
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

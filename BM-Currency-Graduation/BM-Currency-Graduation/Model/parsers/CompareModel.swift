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
    var result: String
    var baseCode: String
    var targetCodes: [String]
    var conversionRates: ConversionRates

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case baseCode = "base_code"
        case targetCodes = "target_codes"
        case conversionRates = "conversion_rates"
    }
}

// MARK: - ConversionRates
struct ConversionRates: Codable {
    var additionalProp1: Int
    var additionalProp2: Int
    var additionalProp3: Int

    enum CodingKeys: String, CodingKey {
        case additionalProp1 = "additionalProp1"
        case additionalProp2 = "additionalProp2"
        case additionalProp3 = "additionalProp3"
    }
}

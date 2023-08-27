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
    var conversionRates: [String:Double]
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case baseCode = "base_code"
        case targetCodes = "target_codes"
        case conversionRates = "conversion_rates"
    }
}

//// MARK: - ConversionRates
//struct ConversionRates: Codable {
//    var jpy: Double
//    var egp: Double
//    
//    enum CodingKeys: String, CodingKey {
//        case jpy = "JPY"
//        case egp = "EGP"
//    }
//}

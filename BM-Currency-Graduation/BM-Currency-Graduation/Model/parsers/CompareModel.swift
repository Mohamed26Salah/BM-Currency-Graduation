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
    var conversionRates: [ConversionRate]
    var timeLastUpdateUTC: String

    enum CodingKeys: String, CodingKey {
        case conversionRates = "conversion_rates"
        case timeLastUpdateUTC = "time_last_update_utc"
    }
}

// MARK: - ConversionRate
struct ConversionRate: Codable {
    var currencyCode: String
    var rate: Double
    var amount: Double

    enum CodingKeys: String, CodingKey {
        case currencyCode = "currencyCode"
        case rate = "rate"
        case amount = "amount"
    }
}

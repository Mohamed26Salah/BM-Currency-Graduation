//
//  AllCurrenciesModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation
import OptionallyDecodable

// MARK: - AllCurrenciesModel
struct AllCurrenciesModel: Codable {
    var currencies: [Currency]

    enum CodingKeys: String, CodingKey {
        case currencies = "currencies"
    }
}

// MARK: - Currency
struct Currency: Codable {
    var code: String
    var flagURL: String
    var desc: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case flagURL = "flagUrl"
        case desc = "desc"
    }
}

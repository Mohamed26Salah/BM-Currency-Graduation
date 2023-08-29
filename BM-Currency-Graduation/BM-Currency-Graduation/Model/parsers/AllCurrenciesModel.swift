//
//  AllCurrenciesModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation
import OptionallyDecodable


struct AllCurrencies: Codable {
    var statusCode: Int
    var status: String
    var message: String
    var data: [CurrencyData]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

// MARK: - Datum
struct CurrencyData: Codable, Equatable {
    var iconURL: String
    var name: String
    var code: String

    enum CodingKeys: String, CodingKey {
        case iconURL = "icon_url"
        case name = "name"
        case code = "code"
    }
}

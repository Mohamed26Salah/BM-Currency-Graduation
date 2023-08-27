//
//  AllCurrenciesModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation
import OptionallyDecodable

// MARK: - CurrenciesArray
struct CurrenciesArray: Codable {
    var name: String
    var code: String
    var iconURL: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "code"
        case iconURL = "icon_url"
    }
}

typealias AllCurrencies = [CurrenciesArray]

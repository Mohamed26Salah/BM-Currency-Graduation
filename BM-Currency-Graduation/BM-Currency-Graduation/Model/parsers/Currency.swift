//
//  Currency.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 02/09/2023.
//

import Foundation
import OptionallyDecodable

struct Currency: Codable, Equatable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    var rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case timestamp = "timestamp"
        case base = "base"
        case date = "date"
        case rates = "rates"
    }
}

extension Currency {
    
    func convertCurrency(amount: Double, from sourceCurrency: String, to targetCurrency: String) -> Double {
        guard let exchangeRateFromSourceToBase = rates[sourceCurrency] else {
            return 0
        }
        
        guard let exchangeRateFromTargetToBase = rates[targetCurrency] else {
            return 0
        }
        
        let valueInBaseCurrency = amount / exchangeRateFromSourceToBase // Convert to base currency
        
        return valueInBaseCurrency * exchangeRateFromTargetToBase // Convert to target currency
    }
    func convertAllCurrencies(amount: Double, from sourceCurrency: String) -> [String:Double]? {
        var newCurrencyDictionary = [String: Double]()
        for currency in rates {
            newCurrencyDictionary[currency.key] = convertCurrency(amount: amount, from: sourceCurrency, to: currency.key)
        }
        return newCurrencyDictionary
    }

}

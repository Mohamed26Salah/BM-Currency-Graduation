//
//  Converstion_Test.swift
//  BM-Currency-GraduationTests
//
//  Created by Mohamed Salah on 29/08/2023.
//

import XCTest
@testable import BM_Currency_Graduation

final class Converstion_Test: XCTestCase {
    
    var currencyVM: CurrencyViewModel!
    
    override func setUpWithError() throws {
        currencyVM = CurrencyViewModel()
    }
    
    override func tearDownWithError() throws {
        currencyVM = nil
    }
    
    func testFillDropDown() {
        // Given
        let currencyArray: [CurrencyData] = [
            CurrencyData(iconURL: "", name: "United States Dollar", code: "USD"),
            CurrencyData(iconURL: "", name: "Euro", code: "EUR")
        ]
        
        let expectedOutput = [
            " 🇺🇸USD",
            " 🇪🇺EUR",
        ]
        
        // When
        let result = currencyVM.fillDropDown(currencyArray: currencyArray)
        
        // Then
        XCTAssertEqual(result, expectedOutput)
    }
    
    func testGetFlagEmoji() {
        // Given
        let flag = "USD"
        let expectedEmoji = "🇺🇸"
        
        // When
        let emoji = currencyVM.getFlagEmoji(flag: flag)
        
        // Then
        XCTAssertEqual(emoji, expectedEmoji)
    }
    
    func testCalculateConvertedAmount() {
        // Given
        let baseAmount = 100.0
        let targetCurrency = "EUR"
        let conversionRates: [String: Double] = [
            "USD": 0.85,
            "EUR": 1.0,
        ]
        
        let expectedConvertedAmount = 100.0 * 1.0 // Since targetCurrency is "EUR"
        
        // When
        let convertedAmount = currencyVM.calculateConvertedAmount(baseAmount: baseAmount, targetCurrency: targetCurrency, conversionRates: conversionRates)
        
        // Then
        XCTAssertEqual(convertedAmount, expectedConvertedAmount)
    }
    
}

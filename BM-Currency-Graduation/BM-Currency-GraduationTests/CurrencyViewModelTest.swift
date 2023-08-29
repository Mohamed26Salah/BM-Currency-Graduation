//
//  CurrencyViewModelTest.swift
//  BM-Currency-GraduationTests
//
//  Created by Mohamed Salah on 29/08/2023.
//

import XCTest
import RxSwift
import RxTest
import RxRelay
import RxCocoa
@testable import BM_Currency_Graduation

final class CurrencyViewModelTest: XCTestCase {
    
    var disposeBag: DisposeBag!
    var sut: CurrencyViewModel!
    var apiServiceMock: APIManagerMock!
    
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        apiServiceMock = APIManagerMock()
        sut = CurrencyViewModel(apiManager: apiServiceMock)
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        apiServiceMock = nil
        sut = nil
    }

        
    
    
    func test_Fetch_Global() {
        let expectedCurrencies = AllCurrencies(statusCode: 200, status: "Good", message: "Done", data: [CurrencyData(iconURL: "", name: "", code: "")])
        apiServiceMock.fetchGlobalResult = Observable.just(expectedCurrencies)
        
        var actualCurrencies: [CurrencyData]?
        apiServiceMock.fetchGlobal(parsingType: AllCurrencies.self, baseURL: APIManager.EndPoint.getCurrencesData.stringToUrl)
            .subscribe(onNext: { currencies in
                actualCurrencies = currencies.data
            })
            .disposed(by: disposeBag)

        XCTAssertEqual(actualCurrencies, expectedCurrencies.data)
    }
    func test_Fetch_Fails() {
        let expectedError = NSError(domain: "TestError", code: -1, userInfo: nil)
        apiServiceMock.fetchGlobalResult = Observable<AllCurrencies>.error(expectedError)
        
        var actualError: Error?
        apiServiceMock.fetchGlobal(parsingType: AllCurrencies.self, baseURL: APIManager.EndPoint.getCurrencesData.stringToUrl)
            .subscribe(onError: { error in
                actualError = error
            })
            .disposed(by: disposeBag)

        XCTAssertEqual(actualError as NSError?, expectedError)
    }
    func test_Get_All_Currencies_Data() {
        let expectedCurrencies = AllCurrencies(statusCode: 200, status: "Good", message: "Done", data: [CurrencyData(iconURL: "", name: "", code: "")])
        apiServiceMock.fetchGlobalResult = Observable.just(expectedCurrencies)
        sut.getAllCurrenciesData()
        XCTAssert(apiServiceMock!.fetchGlobalCalled)
    }

    func test_convert_Currency() {
        let expectedConvertCurrency = ConvertModel(statusCode: 200, status: "Good", message: "Done", data: ConvertRate(baseCode: "USD", targetCode: "EGP", conversionRate: 1, conversionResult: 31))
        apiServiceMock.fetchGlobalResult = Observable.just(expectedConvertCurrency)
        sut.convertCurrency(amount: "20", from: "USD", to: "EGP")
        XCTAssert(apiServiceMock!.fetchGlobalCalled)
    }

    func test_Compare_Currency() {
        let expectedCompareCurrency = CompareModel(statusCode: 200, status: "Good", message: "Done", data: CompareData(result: "", baseCode: "", targetCodes: [""], conversionRates: ["":0.0]))
        apiServiceMock.fetchGlobalResult = Observable.just(expectedCompareCurrency)
        sut.compareCurrency(amount: "10", from: "USD", toFirstCurrency: "EGP", toSecoundCurrency: "KWD")
        XCTAssert(apiServiceMock!.fetchGlobalCalled)
    }
    func test_Get_ConvertionRate() {
        let expectedConverstionRate = Converstion(statusCode: 200, status: "Good", message: "Done", data: ConverstionRate(baseCode: "USD", targetCode: "EGP", conversionRate: 1053450))
        apiServiceMock.fetchGlobalResult = Observable.just(expectedConverstionRate)
        sut.getConvertionRate(from: "USD", to: "EGP") { converstionRate in
            XCTAssertEqual(String(format: "%.2f", expectedConverstionRate.data.conversionRate), converstionRate)
        }
        XCTAssert(apiServiceMock!.fetchGlobalCalled)
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
        let result = sut.fillDropDown(currencyArray: currencyArray)
        
        // Then
        XCTAssertEqual(result, expectedOutput)
    }
    
    func testGetFlagEmoji() {
        // Given
        let flag = "USD"
        let expectedEmoji = "🇺🇸"
        
        // When
        let emoji = sut.getFlagEmoji(flag: flag)
        
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
        let convertedAmount = sut.calculateConvertedAmount(baseAmount: baseAmount, targetCurrency: targetCurrency, conversionRates: conversionRates)
        
        // Then
        XCTAssertEqual(convertedAmount, expectedConvertedAmount)
    }
}

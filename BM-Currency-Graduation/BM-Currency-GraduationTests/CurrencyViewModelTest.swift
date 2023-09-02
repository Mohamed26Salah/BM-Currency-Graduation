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
        let expectedCurrencies = Currency(success: true, timestamp: 1, base: "EUR", date: "today", rates: ["USD":25, "EUR":26])
        apiServiceMock.fetchGlobalResult = Observable.just(expectedCurrencies)
        
        var actualCurrencies: Currency?
        apiServiceMock.fetchGlobal(parsingType: Currency.self, baseURL: APIManager.EndPoint.rates.stringToUrl)
            .subscribe(onNext: { currencies in
                actualCurrencies = currencies
            })
            .disposed(by: disposeBag)

        XCTAssertEqual(actualCurrencies, expectedCurrencies)
    }
    func test_Fetch_Fails() {
        let expectedError = NSError(domain: "TestError", code: -1, userInfo: nil)
        apiServiceMock.fetchGlobalResult = Observable<Currency>.error(expectedError)
        
        var actualError: Error?
        apiServiceMock.fetchGlobal(parsingType: Currency.self, baseURL: APIManager.EndPoint.rates.stringToUrl)
            .subscribe(onError: { error in
                actualError = error
            })
            .disposed(by: disposeBag)

        XCTAssertEqual(actualError as NSError?, expectedError)
    }
    func test_Get_All_Currencies_Data() {
        let expectedCurrencies =  Currency(success: true, timestamp: 1, base: "EUR", date: "today", rates: ["USD":25, "EUR":26])
        apiServiceMock.fetchGlobalResult = Observable.just(expectedCurrencies)
        sut.getAllCurrenciesData()
        XCTAssert(apiServiceMock!.fetchGlobalCalled)
    }
    
    func testFetchGlobal() {
        let sampleResponse = Currency(success: true, timestamp: 1, base: "EUR", date: "today", rates: ["USD":25, "EUR":26])
        apiServiceMock.fetchGlobalResult = Observable.just(sampleResponse)

        let resultObservable: Observable<Currency> = apiServiceMock.fetchGlobal(
            parsingType: Currency.self,
            baseURL: URL(string: "https://example.com")!
        )

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Currency.self)

        resultObservable.subscribe(observer).disposed(by: DisposeBag())

        XCTAssertTrue(apiServiceMock.fetchGlobalCalled)

        XCTAssertNotEqual(observer.events, [Recorded.next(0, sampleResponse)])
    }
    func testFillDropDown() {
        // Given
        let currencyDict: [String:Double] = ["USD":25, "EUR":26]
        
        let expectedOutput = [
            " 🇺🇸USD",
            " 🇪🇺EUR",
        ]
        
        // When
        let result = sut.fillDropDown(currencyDict: currencyDict)
        
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
    func testImageLink() {
        let currencyCode = "EGP"
        let expectedImageFlag = URL(string: "https://flagsapi.com/EG/flat/64.png")
        let convertedCurrecnyCodeToFlag = sut.imageURL(currecnyCode: currencyCode)
        XCTAssertEqual(expectedImageFlag, convertedCurrecnyCodeToFlag)
    }
}

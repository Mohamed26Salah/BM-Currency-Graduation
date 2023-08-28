//
//  API-Manager-Test.swift
//  BM-Currency-GraduationTests
//
//  Created by Mohamed Salah on 28/08/2023.
//

import XCTest
import RxSwift
import RxRelay
import RxCocoa

@testable import BM_Currency_Graduation

final class API_Manager_Test: XCTestCase {
    let disposeBag = DisposeBag()

    var apiManager: APIManager!
    
    override func setUpWithError() throws {
        apiManager = APIManager.shared()
    }

    override func tearDownWithError() throws {
       apiManager = nil
    }

    func testAPIManagerSuccessful() {
        let promise = XCTestExpectation(description: "Done")
        var responseError: Error?
        var allCurrencies: AllCurrencies?
        guard let bundle = Bundle.unitTest.path(forResource: "stub", ofType: "json") else {
            XCTFail("Fail")
            return
        }
        apiManager.fetchGlobal(parsingType: AllCurrencies.self, baseURL: URL(fileURLWithPath: bundle))
            .subscribe(onNext: { currencyArray in
                allCurrencies = currencyArray
            }, onError: { error in
                responseError = error
            })
            .disposed(by: disposeBag)
        promise.fulfill()
        wait(for: [promise], timeout: 1)
        XCTAssertNil(responseError)
        XCTAssertNotNil(allCurrencies)
    }

}

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
import RxTest

@testable import BM_Currency_Graduation

final class API_Manager_Test: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var networkService: APIManager! // Replace with your network service protocol
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        networkService = APIManager.shared() // Replace with your network service implementation
    }
    
//    func testFetchGlobal_Success() {
//        // Given
//        let bundle = Bundle(for: type(of: self))
//        guard let jsonPath = bundle.path(forResource: "stub", ofType: "json"),
//              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)),
//              let expectedData = try? JSONDecoder().decode(AllCurrencies.self, from: jsonData) else {
//            XCTFail("Failed to load stub JSON or decode it")
//            return
//        }
//        
//        let mockSession = MockURLSession()
//        let networkService = YourNetworkServiceImplementation(session: mockSession)
//        
//        mockSession.mockResponse = MockURLSession.mockResponse(statusCode: 200, data: jsonData)
//        
//        // When
//        let fetchObservable = networkService.fetchGlobal(parsingType: YourCodableType.self, baseURL: URL(string: "https://example.com")!)
//        
//        // Then
//        let observer = scheduler.createObserver(YourCodableType.self)
//        
//        scheduler.scheduleAt(0) {
//            fetchObservable
//                .subscribe(observer)
//                .disposed(by: self.disposeBag)
//        }
//        
//        scheduler.start()
//        
//        XCTAssertEqual(observer.events, [.next(0, expectedData)])
//    }

}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let completionHandler: (Data?, URLResponse?, Error?) -> Void
    
    init(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func resume() {
        completionHandler(nil, nil, nil) // Call the completion handler with your mock data, response, and error
    }
}

class MockURLSession: URLSessionProtocol {
    var mockResponse: (data: Data?, response: URLResponse?, error: Error?)?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let data = mockResponse?.data
        let response = mockResponse?.response
        let error = mockResponse?.error
        
        return MockURLSessionDataTask(data: data, response: response, error: error, completionHandler: completionHandler)
    }
}

extension MockURLSession {
    static func mockResponse(statusCode: Int, data: Data? = nil) -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "https://concurrency-api.onrender.com/api/v1/currencies")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}


//func testAPIManagerSuccessful() {
//    let promise = XCTestExpectation(description: "Done")
//    var responseError: Error?
//    var allCurrencies: AllCurrencies?
//    guard let bundle = Bundle.unitTest.path(forResource: "stub", ofType: "json") else {
//        XCTFail("Fail")
//        return
//    }
//    apiManager.fetchGlobal(parsingType: AllCurrencies.self, baseURL: URL(fileURLWithPath: bundle))
//        .subscribe(onNext: { currencyArray in
//            allCurrencies = currencyArray
//        }, onError: { error in
//            responseError = error
//        })
//        .disposed(by: disposeBag)
//    promise.fulfill()
//    wait(for: [promise], timeout: 1)
//    XCTAssertNil(responseError)
//    XCTAssertNotNil(allCurrencies)
//}

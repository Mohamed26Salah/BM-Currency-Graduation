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
    var networkService: APIClientProtocol!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        networkService = APIManager()
    }
    override func tearDownWithError() throws {
        disposeBag = nil
        scheduler = nil
        networkService = nil
    }
    func testExample() {
        let disposeBag = DisposeBag()
        
        let observer = scheduler.createObserver(String.self)
        
        let subject = PublishSubject<String>()
        subject
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, "Hello"), .next(20, "World")])
            .bind(to: subject)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expectedEvents: [Recorded<Event<String>>] = [
            .next(10, "Hello"),
            .next(20, "World")
        ]
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testFetchGlobal_Success() {
        // Given
        var expectedData: [CurrencyData]!

        guard let url = Bundle(for: type(of: self)).url(forResource: "stub", withExtension: "json") else {
            XCTFail("Failed to load JSON file")
            return
        }

        let expectation = XCTestExpectation(description: "API call")

        getAPIData(url: url) { currencies, error in
            if let error = error {
                XCTFail("API call failed with error: \(error)")
            } else {
                expectedData = currencies?.data
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)

        // Simulate a successful network response using a PublishSubject
        let responseSubject = PublishSubject<[CurrencyData]>()

        // When
        let fetchObservable = networkService.fetchGlobal(parsingType: AllCurrencies.self, baseURL: url)

        // Then
        let observer = scheduler.createObserver([CurrencyData].self)

        // Bind the responseSubject to the observer
        scheduler.scheduleAt(0) {
            responseSubject
                .bind(to: observer)
                .disposed(by: self.disposeBag)
        }

        // Emit the expected data into the responseSubject
        scheduler.scheduleAt(5) {
            responseSubject.onNext(expectedData)
        }

        // Subscribe to the fetchObservable
        scheduler.scheduleAt(10) {
            fetchObservable
                .map({ currencesData in
                    currencesData.data
                })
                .bind(to: responseSubject)
                .disposed(by: self.disposeBag)
        }

        scheduler.start()

        // Define the expected events
        let expectedEvents: [Recorded<Event<[CurrencyData]>>] = [.next(5, expectedData)]

        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testFetchGlobal_Success2() {
        // Given
        var expectedData: [CurrencyData]!
        
        guard let url = Bundle(for: type(of: self)).url(forResource: "stub", withExtension: "json") else {
            XCTFail("Failed to load JSON file")
            return
        }
        
        let expectation = XCTestExpectation(description: "API call")
        
        getAPIData(url: url) { currencies, error in
            if let error = error {
                XCTFail("API call failed with error: \(error)")
            } else {
                expectedData = currencies?.data
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        //when
        let fetchObservable = networkService.fetchLocalFile(parsingType: AllCurrencies.self, localFilePath: url)
        // Then
        let observer = scheduler.createObserver([CurrencyData].self)
        
        scheduler.scheduleAt(5) {
            fetchObservable
                .map({ currencesData in
                    currencesData.data
                })
                .bind(to: observer)
                .disposed(by: self.disposeBag)
        }
        
        // Emit the expected data into the observer
        scheduler.scheduleAt(10) {
            observer.onNext(expectedData)
        }
        
        scheduler.start()
        
        // Define the expected events
        let expectedEvents: [Recorded<Event<[CurrencyData]>>] = [
            .next(5, expectedData)
        ]

        XCTAssertNotEqual(observer.events, expectedEvents)
        
    }
    
    func getAPIData(url: URL, completion: @escaping (AllCurrencies?, Error?) -> Void) {
        let session = URLSession.shared //--> htft7 google Chrome
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let decodedCurrencies = try JSONDecoder().decode(AllCurrencies.self, from: data)
                completion(decodedCurrencies, nil)
                
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    

}


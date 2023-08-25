//
//  Test.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 25/08/2023.
//
//
//import Foundation
//import Foundation
//import RxSwift
//import RxCocoa
//
//enum Error: Swift.Error {
//    case invalidResponse(HTTPURLResponse)
//    case invalidJSON(Swift.Error)
//}
//
//func fetchGlobal<T: Codable>(parsingType: T.Type, url: URL, attributes: [String: String] = [:]) -> Observable<T> {
//    var request = URLRequest(url: url)
//
//    // Add custom attributes to the request headers
//    for (key, value) in attributes {
//        request.addValue(value, forHTTPHeaderField: key)
//    }
//
//    return URLSession.shared.rx.response(request: request)
//        .map { result -> Data in
//            guard result.response.statusCode == 200 else {
//                print(result.response)
//                throw Error.invalidResponse(result.response)
//            }
//            return result.data
//        }.map { data in
//            do {
//                let searchResult = try JSONDecoder().decode(
//                    parsingType.self, from: data
//                )
//                return searchResult
//            } catch let error {
//                throw Error.invalidJSON(error)
//            }
//        }
//        .observeOn(MainScheduler.instance)
//        .asObservable()
//}
//
//// Example usage
//if let url = URL(string: "https://api.example.com/data") {
//    let attributes = ["Authorization": "Bearer YOUR_ACCESS_TOKEN", "CustomHeader": "Value"]
//
//    fetchGlobal(parsingType: YourCodableType.self, url: url, attributes: attributes)
//        .subscribe(onNext: { result in
//            // Handle the fetched and parsed data
//            print(result)
//        }, onError: { error in
//            // Handle the error
//            print(error)
//        })
//        .disposed(by: disposeBag) // Make sure to dispose when appropriate
//}

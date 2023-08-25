//
//  APIManager.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 25/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class APIManager {
    
    private init() {}
    
    private static let sharedInstance = APIManager()
    
    static func shared() -> APIManager {
        return APIManager.sharedInstance
    }
   
    
    let disposeBag = DisposeBag()
    enum EndPoint {
        case getCurrencesData
        case convertCurrency
        case compareCurrencies
        
        var stringValue: String {
            switch self {
            case .getCurrencesData:
                return K.Links.baseURL + "v1"
            case .convertCurrency:
                return K.Links.baseURL + "v2/conversion?"
            case .compareCurrencies:
                return K.Links.baseURL + "v2/comparison?"
            }
        }
        var stringToUrl: URL {
            return URL(string: stringValue)!
        }
    }
    private enum Error: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }
    
    func fetchGlobal<T: Codable>(parsingType: T.Type, url: URL, attributes: [String: String]? = nil) -> Observable<T> {
        var request = URLRequest(url: url)
        if let attributes = attributes {
            for (key, value) in attributes {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    print(result.response)
                    throw Error.invalidResponse(result.response)
                }
                return result.data
            }.map { data in
                do {
                    let searchResult = try JSONDecoder().decode(
                        parsingType.self, from: data
                    )
                    return searchResult
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
}

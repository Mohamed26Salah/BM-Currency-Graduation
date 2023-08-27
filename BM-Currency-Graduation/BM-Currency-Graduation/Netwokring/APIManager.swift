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
//        case convertCurrency
        case compareCurrencies
        
        var stringValue: String {
            switch self {
            case .getCurrencesData:
                return K.Links.newBaseURL
//            case .convertCurrency:
//                return K.Links.baseURL + "v2/conversion?"
            case .compareCurrencies:
                return K.Links.baseURL + "comparison?"
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
    
    func fetchGlobal<T: Codable>(
        parsingType: T.Type,
        baseURL: URL,
        attributes: [String]? = nil,
        queryParameters: [String: String]? = nil,
        jsonBody: [String: Any]? = nil
    ) -> Observable<T> {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        if let attributes = attributes, !attributes.isEmpty {
            components.path += "/" + attributes.joined(separator: "/")
        }
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = jsonBody != nil ? "POST" : "GET"
        
        if let jsonBody = jsonBody {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
            request.httpBody = jsonData
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
                    let decodedData = try JSONDecoder().decode(
                        parsingType.self, from: data
                    )
                    return decodedData
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
}

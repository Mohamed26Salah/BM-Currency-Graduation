
import Foundation
import RxSwift
import RxCocoa

enum Error: Swift.Error {
    case invalidResponse(HTTPURLResponse)
    case invalidJSON(Swift.Error)
}
func fetchGlobal2<T: Codable>(
    parsingType: T.Type,
    baseURL: URL,
    attributes: [String]? = nil,
    queryParameters: [String: String]? = nil,
    jsonBody: [String: Any]? = nil
) -> Observable<T> {
    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
    if let attributes = attributes, !attributes.isEmpty {
        components.path = "/api/v1/currencies/" + attributes.joined(separator: "/")
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
//        let baseeURL = "https://concurrency-api.onrender.com/api/v1/currencies/comparison"
//        let jsoneBody: [String: Any] = [
//            "base_code": "USD",
//            "target_codes": ["EGP", "JPY"]
//        ]
//
//        AF.request(baseeURL, method: .post, parameters: jsoneBody, encoding: JSONEncoding.default)
//            .responseDecodable(of: CompareModel.self) { response in
//                switch response.result {
//                case .success(let value):
//                    print("Success:", value)
//                    print("AAAAAAAAAAAAAAAAAAAAAA")
//                case .failure(let error):
//                    print("Error:", error)
//                }
//            }

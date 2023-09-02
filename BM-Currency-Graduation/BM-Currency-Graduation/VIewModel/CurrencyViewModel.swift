//
//  CurrencyViewModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyViewModel {
    
    let apiManager: APIClientProtocol
    init( apiManager: APIClientProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    private let disposeBag = DisposeBag()
    var allCurrenciesModel: AllCurrencies?
   
    //In
    var fromCurrency = BehaviorRelay<String>(value: "EGP")

    //Out
    var errorSubject = PublishSubject<Error>()
    var showLoading = BehaviorRelay<Bool>(value: false)
    var convertion = PublishRelay<String>.init()
    var firstComparedCurrency = PublishRelay<String>.init()
    var secoundComparedCurrency = PublishRelay<String>.init()
    var currenciesArray = PublishRelay<[CurrencyData]>.init()
    var favouritesArray = BehaviorRelay<[FavouriteItem]>(value: FavouritesManager.shared().getAllFavoriteItems())
    

    func getAllCurrenciesData() {
        apiManager.fetchGlobal(parsingType: AllCurrencies.self, baseURL: APIManager.EndPoint.getCurrencesData.stringToUrl)
            .subscribe(onNext: { ListOFAllCurrenciesModel in
                self.showLoading.accept(false)
                self.allCurrenciesModel = ListOFAllCurrenciesModel
                self.currenciesArray.accept(ListOFAllCurrenciesModel.data)
            }, onError: { error in
                self.errorSubject.onNext(error)
                self.showLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    func convertCurrency(amount: String, from: String, to: String) {
        apiManager.fetchGlobal(parsingType: ConvertModel.self, baseURL: APIManager.EndPoint.convertCurrency.stringToUrl, attributes: [from, to, amount])
            .subscribe(onNext: { convertion in
                self.showLoading.accept(false)
                self.convertion.accept(String(format: "%.2f", convertion.data.conversionResult))
            }, onError: { error in
                self.errorSubject.onNext(error)
                self.showLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    func compareCurrency(amount: String, from: String, toFirstCurrency: String, toSecoundCurrency: String) {
        let currencyList = [toFirstCurrency, toSecoundCurrency]
        let body: [String : Any] = ["base_code":from, "target_codes":currencyList]
        let apiManager2 = APIManager()
        apiManager2.fetchGlobal(parsingType: CompareModel.self, baseURL: APIManager.EndPoint.compareCurrencies.stringToUrl, jsonBody: body)
            .subscribe { compareModel in
                self.showLoading.accept(false)
                self.firstComparedCurrency.accept(String(format: "%.2f", self.calculateConvertedAmount(baseAmount: Double(amount) ?? 1.0, targetCurrency: toFirstCurrency, conversionRates: compareModel.data.conversionRates) ?? 1.0))
                self.secoundComparedCurrency.accept(String(format: "%.2f", self.calculateConvertedAmount(baseAmount: Double(amount) ?? 1.0, targetCurrency: toSecoundCurrency, conversionRates: compareModel.data.conversionRates) ?? 1.0))
            } onError: { error in
                self.errorSubject.onNext(error)
                self.showLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    func getConvertionRate(from: String, to: String, completion: @escaping (String?) -> Void) {
        apiManager.fetchGlobal(parsingType: Converstion.self, baseURL: APIManager.EndPoint.convertCurrency.stringToUrl, attributes: [from, to])
            .subscribe { converstion in
                completion(String(format: "%.2f", converstion.data.conversionRate))
            } onError: { error in
                self.errorSubject.onNext(error)
                self.showLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
//MARK: Helping Functions
extension CurrencyViewModel {
    func fillDropDown(currencyArray: [CurrencyData]) -> [String] {
        var arr = [String]()
        for flag in currencyArray {
            arr.append(" " + getFlagEmoji(flag: flag.code) + flag.code)
        }
        
        return arr
    }
    func getFlagEmoji(flag: String) -> String{
        let code = flag.dropLast()
        let base: UInt32 = 127397
        var emoji = ""
        for scalar in code.unicodeScalars {
            emoji.append(String(UnicodeScalar(base + scalar.value)!))
        }
        return emoji
    }
    func calculateConvertedAmount(baseAmount: Double, targetCurrency: String, conversionRates: [String:Double]) -> Double? {
        if let rate = conversionRates[targetCurrency] {
            return baseAmount * rate
        }
        return nil
    }
}

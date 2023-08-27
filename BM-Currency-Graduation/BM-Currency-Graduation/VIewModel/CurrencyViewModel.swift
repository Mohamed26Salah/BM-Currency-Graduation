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
    private let disposeBag = DisposeBag()
    var allCurrenciesModel: AllCurrencies?
    //In
    var errorSubject = PublishSubject<String>()
    //Out
    var convertion = PublishRelay<String>.init()
    var firstComparedCurrency = PublishRelay<String>.init()
    var secoundComparedCurrency = PublishRelay<String>.init()
    var currenciesArray = PublishRelay<AllCurrencies>.init()
    var favouritesArray = BehaviorRelay<[FavouriteItem]>(value: FavouritesManager.shared().getAllFavoriteItems())
    
//    init() {
//        self.getAllCurrenciesData()
//    }
    func getAllCurrenciesData() {
        APIManager.shared().fetchGlobal(parsingType: AllCurrencies.self, baseURL: APIManager.EndPoint.getCurrencesData.stringToUrl)
            .subscribe(onNext: { ListOFAllCurrenciesModel in
                self.allCurrenciesModel = ListOFAllCurrenciesModel
                self.currenciesArray.accept(ListOFAllCurrenciesModel)
            }, onError: { error in
                print(error)
                self.errorSubject.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    func convertCurrency(amount: String, from: String, to: String) {
        APIManager.shared().fetchGlobal(parsingType: ConvertModel.self, baseURL: APIManager.EndPoint.getCurrencesData.stringToUrl, attributes: [from, to, amount])
            .subscribe(onNext: { convertion in
                self.convertion.accept(String(format: "%.2f", convertion.conversionResult))
            }, onError: { error in
                print(error)
                self.errorSubject.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    func compareCurrency(amount: String, from: String, toFirstCurrency: String, toSecoundCurrency: String) {
        let currencyList = [toFirstCurrency, toSecoundCurrency]
        let body: [String : Any] = ["base_code":from, "target_codes":currencyList]
        APIManager.shared().fetchGlobal(parsingType: CompareModel.self, baseURL: APIManager.EndPoint.compareCurrencies.stringToUrl, jsonBody: body)
            .subscribe { compareModel in
                self.firstComparedCurrency.accept(String(self.calculateConvertedAmount(baseAmount: Double(amount) ?? 1.0, targetCurrency: toFirstCurrency, conversionRates: compareModel.conversionRates) ?? 1.0))
                self.secoundComparedCurrency.accept(String(self.calculateConvertedAmount(baseAmount: Double(amount) ?? 1.0, targetCurrency: toSecoundCurrency, conversionRates: compareModel.conversionRates) ?? 1.0))
            } onError: { error in
                print(error)
                self.errorSubject.onNext(error.localizedDescription)
            }
            .disposed(by: disposeBag)

    }
    
    
}
//MARK: Helping Functions
extension CurrencyViewModel {
    func fillDropDown(currencyArray: AllCurrencies) -> [String] {
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

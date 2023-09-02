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
        setupBinding()
    }
    private let disposeBag = DisposeBag()
    var allCurrenciesModel: Currency?
   
    
    //New
    // In
    var fromCurrencyRelay = BehaviorRelay<String>(value: "EGP")
    var toCurrencyRelay = BehaviorRelay<String>(value: "USD")
    var fromAmountRelay = PublishRelay<Double>.init()
    var toAmountRelay = PublishRelay<Double>.init()
    //Out
    var toCurrencyOutPutRelay = PublishRelay<String>.init()
    var fromCurrencyOutPutRelay = PublishRelay<String>.init()
    var placeholderOutputRelay = PublishRelay<String>.init()
    var CurrencyRates = BehaviorRelay<[String:Double]>(value: ["EUR":0.0])
    var CurrencyData = BehaviorRelay<[String:Double]>(value: ["EUR":0.0])
    var favouritesArray = BehaviorRelay<[FavouriteItem]>(value: FavouritesManager.shared().getAllFavoriteItems())
    var errorSubject = PublishSubject<Error>()
    var showLoading = BehaviorRelay<Bool>(value: false)

    func getAllCurrenciesData() {
        apiManager.fetchGlobal(parsingType: Currency.self, baseURL: APIManager.EndPoint.rates.stringToUrl)
            .subscribe(onNext: { ListOFAllCurrenciesModel in
                self.showLoading.accept(false)
                self.allCurrenciesModel = ListOFAllCurrenciesModel
                self.fromCurrencyOutPutRelay.accept("1.0")
                self.toCurrencyOutPutRelay.accept(String.init(ListOFAllCurrenciesModel.convertCurrency(amount: 1, from: "EGP", to: "USD")))
                self.CurrencyRates.accept(ListOFAllCurrenciesModel.rates)
                //Made Another one as the CurrencyRates changes
                self.CurrencyData.accept(ListOFAllCurrenciesModel.rates)
            }, onError: { error in
                self.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    private func setupBinding() {
        //combineLatest waits for all the source observables to emit at least one value before it starts combining them and emitting combined results.
        let fromObserable = Observable.combineLatest(fromAmountRelay, fromCurrencyRelay, toCurrencyRelay)
        fromObserable.subscribe(onNext: { [weak self] (amount, from, to) in
            print("Salah 1")
            guard let self = self, let model = self.allCurrenciesModel else { return }
            let convertedAmount = model.convertCurrency(amount: amount, from: from, to: to)
            self.toCurrencyOutPutRelay.accept(String.init(convertedAmount))
            if let newCurrenciesValue = model.convertAllCurrencies(amount: amount, from: from) {
                self.CurrencyRates.accept(newCurrenciesValue)
            }
        }).disposed(by: disposeBag)
        
        let toObserable = Observable.combineLatest(toAmountRelay, toCurrencyRelay, fromCurrencyRelay)
        toObserable.subscribe(onNext: { [weak self] (amount, from, to) in
            print("Salah 2")
            guard let self = self, let model = self.allCurrenciesModel else { return }
            let convertedAmount = model.convertCurrency(amount: amount, from: from, to: to)
            self.fromCurrencyOutPutRelay.accept(String.init(convertedAmount))
            if let newCurrenciesValue = model.convertAllCurrencies(amount: amount, from: from) {
                self.CurrencyRates.accept(newCurrenciesValue)
            }
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(fromCurrencyRelay, toCurrencyRelay).subscribe(onNext: { [weak self] (from, to) in
            print("Salah 3")
            guard let self = self, let model = self.allCurrenciesModel else { return }
            let amount = model.convertCurrency(amount: 1, from: from, to: to)
            self.placeholderOutputRelay.accept(String.init(amount))
        }).disposed(by: disposeBag)
    }
}
//MARK: Helping Functions
extension CurrencyViewModel {
    func fillDropDown(currencyDict: [String:Double]) -> [String] {
        var arr = [String]()
        for (key,_) in currencyDict {
            arr.append(" " + getFlagEmoji(flag: key) + key)
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
    func imageURL(currecnyCode: String) -> URL {
        let currCode = currecnyCode.dropLast()
        return URL(string: "https://flagsapi.com/\(currCode)/flat/64.png") ?? URL(string: "https://flagsapi.com/EG/flat/64.png")!
    }
}

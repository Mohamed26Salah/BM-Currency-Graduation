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
    var toCurrencyRelaySecound = BehaviorRelay<String>(value: "EUR")
    var fromAmountRelay = BehaviorRelay<Double>(value: 1.0)
    var toAmountRelay = PublishRelay<Double>.init()
    
    //Out
    var toCurrencyOutPutRelay = PublishRelay<String>.init()
    var toCurrencyOutPutRelaySecound = PublishRelay<String>.init()
    var fromCurrencyOutPutRelay = PublishRelay<String>.init()
    var CurrencyData = BehaviorRelay<[String:Double]>(value: ["EUR":0.0])
    var favouritesArray = BehaviorRelay<[FavouriteItem]>(value: FavouritesManager.shared().getAllFavoriteItems())
    var errorSubject = PublishSubject<Error>()
    var showLoading = BehaviorRelay<Bool>(value: false)

    func getAllCurrenciesData() {
        apiManager.fetchGlobal(parsingType: Currency.self, baseURL: APIManager.EndPoint.rates.stringToUrl)
            .subscribe(onNext: { ListOFAllCurrenciesModel in
                self.showLoading.accept(false)
                self.allCurrenciesModel = ListOFAllCurrenciesModel
                self.fromAmountRelay.accept(1.0) //To Trigger the Bindings to work
                self.CurrencyData.accept(ListOFAllCurrenciesModel.rates)
            }, onError: { error in
                self.errorSubject.onNext(error)
                self.showLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    private func setupBinding() {
        //combineLatest waits for all the source observables to emit at least one value before it starts combining them and emitting combined results.
        let fromObserable = Observable.combineLatest(fromAmountRelay, fromCurrencyRelay, toCurrencyRelay)
        fromObserable.subscribe(onNext: { [weak self] (amount, from, to) in
            guard let self = self, let model = self.allCurrenciesModel else { return }
            let convertedAmount = model.convertCurrency(amount: amount, from: from, to: to)
            self.toCurrencyOutPutRelay.accept(String.init(format: "%.2f", convertedAmount))
        }).disposed(by: disposeBag)
        
        let toObserable = Observable.combineLatest(toAmountRelay, toCurrencyRelay, fromCurrencyRelay)
        toObserable.subscribe(onNext: { [weak self] (amount, from, to) in
            guard let self = self, let model = self.allCurrenciesModel else { return }
            let convertedAmount = model.convertCurrency(amount: amount, from: from, to: to)
            self.fromCurrencyOutPutRelay.accept(String.init(format: "%.2f", convertedAmount))
        }).disposed(by: disposeBag)
    
        Observable.combineLatest(fromAmountRelay, fromCurrencyRelay, toCurrencyRelay, toCurrencyRelaySecound)
            .subscribe(onNext: { [weak self] (amount, from, to, secoundTo) in
            guard let self = self, let model = self.allCurrenciesModel else { return }
            let convertedAmount = model.convertCurrency(amount: amount, from: from, to: to)
            self.toCurrencyOutPutRelay.accept(String.init(format: "%.2f", convertedAmount))
            let convertedAmount2 = model.convertCurrency(amount: amount, from: from, to: secoundTo)
            self.toCurrencyOutPutRelaySecound.accept(String.init(format: "%.2f", convertedAmount2))
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

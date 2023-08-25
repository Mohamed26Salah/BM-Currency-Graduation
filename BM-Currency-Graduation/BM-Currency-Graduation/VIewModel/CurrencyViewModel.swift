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
    var allCurrenciesModel: AllCurrenciesModel?
    //In
    var errorSubject = PublishSubject<String>()
    //Out
    var currenciesArray = PublishRelay<[Currency]>.init()
    
//    init() {
//        self.getAllCurrenciesData()
//    }
    func getAllCurrenciesData() {
        APIManager.shared().fetchGlobal(parsingType: AllCurrenciesModel.self, url: APIManager.EndPoint.getCurrencesData.stringToUrl)
            .subscribe(onNext: { ListOFAllCurrenciesModel in
                self.allCurrenciesModel = ListOFAllCurrenciesModel
                self.currenciesArray.accept(ListOFAllCurrenciesModel.currencies)
            }, onError: { error in
                print(error)
                self.errorSubject.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    
}

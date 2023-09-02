//
//  CompareViewController.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 23/08/2023.
//

import UIKit
import iOSDropDown
import RxSwift
import RxCocoa
import RxRelay

class CompareViewController: UIViewController {
   
    @IBOutlet weak var fromAmountTextField: UITextField!
    @IBOutlet weak var fromCurrency: DropDown!
    @IBOutlet weak var firstToCurrency: DropDown!
    @IBOutlet weak var secoundToCurrency: DropDown!
    @IBOutlet weak var firstToAmountTextField: UITextField!
    @IBOutlet weak var secoundToAmountTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var compareButton: UIButton!
    
    
    var currencyVM = CurrencyViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyVM.getAllCurrenciesData()
        setupDropDown()
        fillDropDownMenus()
        setupUI()
        bindViewModelToViews()
        subscribeToDropDown()
        bindViewsToViewModel()
        handleLoadingIndicator()
        manageIndicator()
        handleErrors()
    }
    
    
    @IBAction func compareButtonTapped(_ sender: UIButton) {
        currencyVM.showLoading.accept(true)
        currencyVM.getAllCurrenciesData()
    }
}
extension CompareViewController {
    func bindViewModelToViews() {
        currencyVM.fromCurrencyOutPutRelay.bind(to: fromAmountTextField.rx.text).disposed(by: disposeBag)
        currencyVM.toCurrencyOutPutRelay.bind(to: firstToAmountTextField.rx.text).disposed(by: disposeBag)
        currencyVM.toCurrencyOutPutRelaySecound.bind(to: secoundToAmountTextField.rx.text).disposed(by: disposeBag)
//        currencyVM.placeholderOutputRelay.bind(to: toAmountTextField.rx.placeholder).disposed(by: disposeBag)
    }
    func subscribeToDropDown() {
        fromCurrency.didSelect{(selectedText , index ,id) in
            self.currencyVM.fromCurrencyRelay.accept(String(selectedText.dropFirst(2)))
        }
        firstToCurrency.didSelect{(selectedText , index ,id) in
            self.currencyVM.toCurrencyRelay.accept(String(selectedText.dropFirst(2)))
        }
        secoundToCurrency.didSelect{(selectedText , index ,id) in
            self.currencyVM.toCurrencyRelaySecound.accept(String(selectedText.dropFirst(2)))
        }
    }
    func bindViewsToViewModel() {
        fromAmountTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(fromAmountTextField.rx.text.orEmpty)
            .map { $0.isEmpty ? "0.0" : $0 }
            .distinctUntilChanged()
            .compactMap(Double.init)
            .bind(to: currencyVM.fromAmountRelay)
            .disposed(by: disposeBag)
    }
}
//MARK: RxFunctions
extension CompareViewController {
    func handleLoadingIndicator() {
        currencyVM.showLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.compareButton.isEnabled = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.compareButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
    }
    func handleErrors() {
        currencyVM.errorSubject
            .subscribe { error in
                self.show(messageAlert: "Error", message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
extension CompareViewController {
    func setupUI() {
        fromAmountTextField.layer.borderWidth = 0.5
        fromAmountTextField.layer.cornerRadius = 20
        fromAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        fromAmountTextField.addLeftPadding(16)

        
        fromCurrency.layer.borderWidth = 0.5
        fromCurrency.layer.cornerRadius = 20
        fromCurrency.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        firstToCurrency.layer.borderWidth = 0.5
        firstToCurrency.layer.cornerRadius = 20
        firstToCurrency.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        
        secoundToCurrency.layer.borderWidth = 0.5
        secoundToCurrency.layer.cornerRadius = 20
        secoundToCurrency.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        firstToAmountTextField.layer.borderWidth = 0.5
        firstToAmountTextField.layer.cornerRadius = 20
        firstToAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        firstToAmountTextField.addLeftPadding(16)
        firstToAmountTextField.isEnabled = false
        
        secoundToAmountTextField.layer.borderWidth = 0.5
        secoundToAmountTextField.layer.cornerRadius = 20
        secoundToAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        secoundToAmountTextField.addLeftPadding(16)
        secoundToAmountTextField.isEnabled = false
    }
    func fillDropDownMenus() {
        currencyVM.CurrencyData
            .subscribe { CurrencyRates in
                self.fromCurrency.optionArray = self.currencyVM.fillDropDown(currencyDict: CurrencyRates)
                self.firstToCurrency.optionArray = self.currencyVM.fillDropDown(currencyDict: CurrencyRates)
                self.secoundToCurrency.optionArray = self.currencyVM.fillDropDown(currencyDict: CurrencyRates)
            }
            .disposed(by: disposeBag)
    }
    func setupDropDown() {
        self.fromCurrency.text = " " + currencyVM.getFlagEmoji(flag: "EGP") + "EGP"
        self.firstToCurrency.text = " " + currencyVM.getFlagEmoji(flag: "USD") + "USD"
        self.secoundToCurrency.text = " " + currencyVM.getFlagEmoji(flag: "EUR") + "EUR"
    }
    func manageIndicator() {
       view.bringSubviewToFront(activityIndicator)
    }
}

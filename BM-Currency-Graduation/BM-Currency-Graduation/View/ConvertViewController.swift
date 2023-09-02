//
//  ConvertViewController.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 23/08/2023.
//

import UIKit
import iOSDropDown
import RxSwift
import RxCocoa
import SDWebImage
import SDWebImageSVGCoder

class ConvertViewController: UIViewController {

    @IBOutlet weak var fromAmountTextField: UITextField!
    @IBOutlet weak var fromCurrency: DropDown!
    @IBOutlet weak var toAmountTextField: UITextField!
    @IBOutlet weak var toCurrency: DropDown!
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var addToFavourites: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    var currencyVM = CurrencyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyVM.getAllCurrenciesData()
        setupUI()
        setupDropDown()
        fillDropDownMenus()
        bindViewModelToViews()
        bindViewsToViewModel()
        showFavouritesData()
        subscribeToDropDown()
        handleLoadingIndicator()
        manageIndicator()
        handleErrors()
    }


    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        currencyVM.showLoading.accept(true)
        currencyVM.getAllCurrenciesData()
    }
    
    @IBAction func addToFavouritesTapped(_ sender: UIButton) {
        let favouritesController = FavouritesScreenVC(currencyVm: currencyVM)
        favouritesController.modalPresentationStyle = .overCurrentContext
        present(favouritesController, animated: true, completion: nil)
    }
    
    @IBAction func swapButtonPressed(_ sender: UIButton) {
        guard let fCurrecny = fromCurrency.text, !fCurrecny.isEmpty,
              let tCurrency = toCurrency.text, !tCurrency.isEmpty else {
            return
        }
        fromCurrency.text = tCurrency
        toCurrency.text = fCurrecny
        currencyVM.fromCurrencyRelay.accept(String(tCurrency.dropFirst(2)))
        currencyVM.toCurrencyRelay.accept(String(fCurrecny.dropFirst(2)))
    }
    
}
extension ConvertViewController {
    func bindViewModelToViews() {
        currencyVM.fromCurrencyOutPutRelay.bind(to: fromAmountTextField.rx.text).disposed(by: disposeBag)
        currencyVM.toCurrencyOutPutRelay.bind(to: toAmountTextField.rx.text).disposed(by: disposeBag)
    }
    func subscribeToDropDown() {
        fromCurrency.didSelect{(selectedText , index ,id) in
            self.currencyVM.fromCurrencyRelay.accept(String(selectedText.dropFirst(2)))
        }
        toCurrency.didSelect{(selectedText , index ,id) in
            self.currencyVM.toCurrencyRelay.accept(String(selectedText.dropFirst(2)))
        }
    }
    func bindViewsToViewModel() {
        //Whenever sourceObservable emits an event, withLatestFrom takes the latest value emitted by otherObservable at that moment.
        //withLatest is comining the event with the value
        fromAmountTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(fromAmountTextField.rx.text.orEmpty)
            .map { $0.isEmpty ? "0.0" : $0 }
            .distinctUntilChanged()
            .compactMap(Double.init)
            .bind(to: currencyVM.fromAmountRelay)
            .disposed(by: disposeBag)
        toAmountTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(toAmountTextField.rx.text.orEmpty)
            .map { $0.isEmpty ? "0.0" : $0 }
            .distinctUntilChanged()
            .compactMap(Double.init)
            .bind(to: currencyVM.toAmountRelay)
            .disposed(by: disposeBag)
    }
}
extension ConvertViewController {
    func showFavouritesData() {
        currencyVM.favouritesArray
            .bind(to: favouritesTableView
                .rx
                .items(cellIdentifier: K.cellsResuable.OutSideFTVCell, cellType: OutSideFTVCell.self)) { [weak self]
                    (tv, curr, cell) in
                    guard let self = self else {
                        return
                    }
                    cell.currencyImage.sd_setImage(with: self.currencyVM.imageURL(currecnyCode: curr.imageUrl))
                    cell.currencyNameLabel.text = curr.currencyCode
                    Observable.combineLatest(self.currencyVM.fromAmountRelay, self.currencyVM.fromCurrencyRelay)
                        .subscribe { [weak self] (amount, fromCurrency) in
                            guard let self = self else { return }
                            if !curr.isInvalidated {
                                cell.currencyAmountLabel.text = String.init(format: "%.2f", currencyVM.allCurrenciesModel?.convertCurrency(amount: amount, from: fromCurrency, to: curr.currencyCode) ?? "N/A" )
                            } else {
                                cell.currencyAmountLabel.text = "N/A"
                            }
                        }
                        .disposed(by: disposeBag)
                }
                .disposed(by: disposeBag)
        currencyVM.favouritesArray
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] isEmpty in
                self?.updateTableViewUI(isEmpty: isEmpty)
            })
            .disposed(by: disposeBag)
    }
    func updateTableViewUI(isEmpty: Bool) {
        if isEmpty {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: favouritesTableView.bounds.size.width, height: favouritesTableView.bounds.size.height))
            noDataLabel.text = "You Haven't added any favoruites yet!"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            favouritesTableView.backgroundView = noDataLabel
            favouritesTableView.separatorStyle = .none
        } else {
            favouritesTableView.backgroundView = nil
            favouritesTableView.separatorStyle = .singleLine
        }
    }
    
}
//MARK: RxFunctions
extension ConvertViewController {
    func handleLoadingIndicator() {
        currencyVM.showLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.convertButton.isEnabled = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.convertButton.isEnabled = true
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
extension ConvertViewController {
    func setupUI() {
        
        favouritesTableView.register(UINib(nibName: K.cellsResuable.OutSideFTVCell, bundle: nil), forCellReuseIdentifier: K.cellsResuable.OutSideFTVCell)

        fromAmountTextField.layer.borderWidth = 0.5
        fromAmountTextField.layer.cornerRadius = 20
        fromAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        fromAmountTextField.addLeftPadding(16)
        
        fromCurrency.layer.borderWidth = 0.5
        fromCurrency.layer.cornerRadius = 20
        fromCurrency.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        toAmountTextField.layer.borderWidth = 0.5
        toAmountTextField.layer.cornerRadius = 20
        toAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        toAmountTextField.addLeftPadding(16)

        
        toCurrency.layer.borderWidth = 0.5
        toCurrency.layer.cornerRadius = 20
        toCurrency.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        addToFavourites.layer.borderWidth = 0.91
        addToFavourites.layer.cornerRadius = 18.12
        addToFavourites.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    }
    func fillDropDownMenus() {
        currencyVM.CurrencyData
            .subscribe { CurrencyRates in
                self.fromCurrency.optionArray = self.currencyVM.fillDropDown(currencyDict: CurrencyRates)
                self.toCurrency.optionArray = self.currencyVM.fillDropDown(currencyDict: CurrencyRates)
            }
            .disposed(by: disposeBag)
    }
    func setupDropDown() {
        fromCurrency.text = " " + currencyVM.getFlagEmoji(flag: "EGP") + "EGP"
        toCurrency.text = " " + currencyVM.getFlagEmoji(flag: "USD") + "USD"
    }
    func manageIndicator() {
        view.bringSubviewToFront(activityIndicator)
    }
}


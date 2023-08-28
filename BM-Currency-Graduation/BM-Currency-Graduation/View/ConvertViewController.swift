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
    
    let disposeBag = DisposeBag()
    var currencyVM = CurrencyViewModel()
//    var comingCurrencyVM: CurrencyViewModel? {
//        didSet {
//            if let currVM = comingCurrencyVM {
//                currencyVM = currVM
//            }
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyVM.getAllCurrenciesData()
        setupUI()
        setupDropDown()
        fillDropDownMenus()
        bindViewModelToViews()
        bindViewslToViewModel()
        showFavouritesData()
        subscribeToDropDown()
    }


    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        guard let fromCurrencyText = fromCurrency.text, !fromCurrencyText.isEmpty,
              let toCurrencyText = toCurrency.text, !toCurrencyText.isEmpty else {
            return
        }
        
        var fromAmount = fromAmountTextField.text ?? "0.0"
        if fromAmount.isEmpty {
            fromAmount = "0.0"
        }
        
        currencyVM.convertCurrency(amount: fromAmount, from: String(fromCurrencyText.dropFirst(2)), to: String(toCurrencyText.dropFirst(2)))
    }
    
    @IBAction func addToFavouritesTapped(_ sender: UIButton) {
        let favouritesController = FavouritesScreenVC(currencyVm: currencyVM)
        favouritesController.modalPresentationStyle = .overCurrentContext
        present(favouritesController, animated: true, completion: nil)

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let nameSelectionVC = storyboard.instantiateViewController(withIdentifier: K.viewsControllers.FavouritesViewController) as! FavouritesViewController
//       nameSelectionVC.modalPresentationStyle = .overCurrentContext
//
//        present(nameSelectionVC, animated: true, completion: nil)
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
                    if let url = URL(string: curr.imageUrl) {
                        cell.currencyImage.sd_setImage(with: url)
                    }
                    cell.currencyNameLabel.text = curr.currencyCode
                    self.currencyVM.fromCurrency
                        .subscribe { fromCurrency in
                            self.currencyVM.getConvertionRate(from: fromCurrency, to: curr.currencyCode) { converstionRate in
                                cell.currencyAmountLabel.text = converstionRate
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
    func bindViewModelToViews() {
        currencyVM.convertion.bind(to: toAmountTextField.rx.text).disposed(by: disposeBag)
    }
    func bindViewslToViewModel() {
//        fromAmountTextField.rx.controlEvent(.editingChanged)
//            .withLatestFrom(fromAmountTextField.rx.text.orEmpty)
//            .map { currency in
//                let cleanedCurrency = String(currency)
//                return cleanedCurrency.isEmpty ? "0.0" : cleanedCurrency
//            }
//            .distinctUntilChanged()
//            .compactMap(Double.init)
//            .bind(to: currencyVM.fromAmount)
//            .disposed(by: disposeBag)

//        fromCurrency.rx.text.orEmpty
//            .map { currency in
//                return String(currency.dropFirst(2))
//            }
//            .distinctUntilChanged()
//            .bind(to: currencyVM.fromCurrency)
//            .disposed(by: disposeBag)

    }
    //the package Doesn't support Rx
    func subscribeToDropDown() {
        fromCurrency.didSelect{(selectedText , index ,id) in
            self.currencyVM.fromCurrency.accept(String(selectedText.dropFirst(2)))
        }
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
        currencyVM.currenciesArray
            .subscribe { currencyArray in
                self.fromCurrency.optionArray = self.currencyVM.fillDropDown(currencyArray: currencyArray)
                self.toCurrency.optionArray = self.currencyVM.fillDropDown(currencyArray: currencyArray)
            }
            .disposed(by: disposeBag)
    }
    func setupDropDown() {
        fromCurrency.text = " " + currencyVM.getFlagEmoji(flag: "EGP") + "EGP"
        toCurrency.text = " " + currencyVM.getFlagEmoji(flag: "USD") + "USD"
    }
}

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

class ConvertViewController: UIViewController {

    @IBOutlet weak var fromAmountTextField: UITextField!
    @IBOutlet weak var fromCurrency: DropDown!
    @IBOutlet weak var toAmountTextField: UITextField!
    @IBOutlet weak var toCurrency: DropDown!
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var addToFavourites: UIButton!
    let disposeBag = DisposeBag()
    var currencyVM = CurrencyViewModel()
//    var comingCurrencyVM: CurrencyViewModel? {
//        didSet {
//            if let currVM = comingCurrencyVM {
//                currencyVM = currVM
//            }
//        }
//    }
    //Temp Values
    let arr = [CurrencyTemp(image: UIImage(named: "USD")!, name: "USD", amount: "1"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "EGB", amount: "12"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "EUR", amount: "123"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "FUK", amount: "1234"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "KSA", amount: "12345"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "MSA", amount: "123456")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyVM.getAllCurrenciesData()
        setupUI()
        setupDropDown()
        fillDropDownMenus()
        bindViewModelToViews()
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
        let favouritesController = FavouritesScreenVC()
        favouritesController.modalPresentationStyle = .overCurrentContext
        present(favouritesController, animated: true, completion: nil)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let nameSelectionVC = storyboard.instantiateViewController(withIdentifier: K.viewsControllers.FavouritesViewController) as! FavouritesViewController
//       nameSelectionVC.modalPresentationStyle = .overCurrentContext
//
//        present(nameSelectionVC, animated: true, completion: nil)
    }
    
}
extension ConvertViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellsResuable.OutSideFTVCell, for: indexPath) as! OutSideFTVCell
        cell.currencyImage.image = arr[indexPath.row].image
        cell.currencyNameLabel.text = arr[indexPath.row].name
        cell.currencyAmountLabel.text = arr[indexPath.row].amount
        return cell
    }
    
    
}
//MARK: RxFunctions
extension ConvertViewController {
    func bindViewModelToViews() {
        currencyVM.convertion.bind(to: toAmountTextField.rx.text).disposed(by: disposeBag)
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

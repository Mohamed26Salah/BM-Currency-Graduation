//
//  ConvertViewController.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 23/08/2023.
//

import UIKit

class ConvertViewController: UIViewController {

    @IBOutlet weak var fromAmountTextField: UITextField!
    @IBOutlet weak var fromCurrency: UITextField!
    @IBOutlet weak var toAmountTextField: UITextField!
    @IBOutlet weak var toCurrency: UITextField!
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var addToFavourites: UIButton!
    //Temp Values
    let arr = [CurrencyTemp(image: UIImage(named: "USD")!, name: "USD", amount: "1"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "EGB", amount: "12"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "EUR", amount: "123"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "FUK", amount: "1234"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "KSA", amount: "12345"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "MSA", amount: "123456")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        print("Convert Button Tapped...")
    }
    
    @IBAction func addToFavouritesTapped(_ sender: UIButton) {
        print("Add To Favourites Button Tapped...")
    }
    
}
extension ConvertViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutSideFTVCell", for: indexPath) as! OutSideFTVCell
        cell.currencyImage.image = arr[indexPath.row].image
        cell.currencyNameLabel.text = arr[indexPath.row].name
        cell.currencyAmountLabel.text = arr[indexPath.row].amount
        return cell
    }
    
    
}
extension ConvertViewController {
    func setupUI() {
        favouritesTableView.register(UINib(nibName: "OutSideFTVCell", bundle: nil), forCellReuseIdentifier: "OutSideFTVCell")
        fromAmountTextField.layer.borderWidth = 0.5
        fromAmountTextField.layer.cornerRadius = 20
        fromAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        fromCurrency.layer.borderWidth = 0.5
        fromCurrency.layer.cornerRadius = 20
        fromCurrency.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        toAmountTextField.layer.borderWidth = 0.5
        toAmountTextField.layer.cornerRadius = 20
        toAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        toCurrency.layer.borderWidth = 0.5
        toCurrency.layer.cornerRadius = 20
        toCurrency.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
        addToFavourites.layer.borderWidth = 0.91
        addToFavourites.layer.cornerRadius = 18.12
        addToFavourites.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    }
}

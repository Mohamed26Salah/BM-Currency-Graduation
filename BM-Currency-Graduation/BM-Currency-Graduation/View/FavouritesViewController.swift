//
//  FavouritesViewController.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 24/08/2023.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    let arr = [CurrencyTemp(image: UIImage(named: "USD")!, name: "USD", amount: "1"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "EGB", amount: "12"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "EUR", amount: "123"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "FUK", amount: "1234"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "KSA", amount: "12345"),
               CurrencyTemp(image: UIImage(named: "USD")!, name: "MSA", amount: "123456")]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func xButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InSideFTVCell", for: indexPath) as! InSideFTVCell
        cell.currencyImage.image = arr[indexPath.row].image
        cell.currencyNameLabel.text = arr[indexPath.row].name
        cell.onFavButtonTapped = {
            print("User Added Currency To Favourites")
            }
        return cell
    }
    
    
}
extension FavouritesViewController {
    func setupUI() {
        view.isOpaque = false
        view.backgroundColor = .clear
        backgroundView.isOpaque = false
        backgroundView.backgroundColor = .clear
        favTableView.register(UINib(nibName: "InSideFTVCell", bundle: nil), forCellReuseIdentifier: "InSideFTVCell")
    }
}

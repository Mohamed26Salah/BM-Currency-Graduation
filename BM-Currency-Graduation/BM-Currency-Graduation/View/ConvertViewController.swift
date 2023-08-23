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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        print("Convert Button Tapped...")
    }
    
}
extension ConvertViewController {
    func setupUI() {
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
    }
}

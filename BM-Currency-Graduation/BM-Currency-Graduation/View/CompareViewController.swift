//
//  CompareViewController.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 23/08/2023.
//

import UIKit

class CompareViewController: UIViewController {
    
    
    @IBOutlet weak var fromAmountTextField: UITextField!
    @IBOutlet weak var fromCurrency: UITextField!
    @IBOutlet weak var firstToCurrency: UITextField!
    @IBOutlet weak var secoundToCurrency: UITextField!
    @IBOutlet weak var firstToAmountTextField: UITextField!
    @IBOutlet weak var secoundToAmountTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func compareButtonTapped(_ sender: UIButton) {
        print("Compare Button Tapped...")
    }
}
extension CompareViewController {
    func setupUI() {
        fromAmountTextField.layer.borderWidth = 0.5
        fromAmountTextField.layer.cornerRadius = 20
        fromAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
        
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
        
        secoundToAmountTextField.layer.borderWidth = 0.5
        secoundToAmountTextField.layer.cornerRadius = 20
        secoundToAmountTextField.layer.borderColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0).cgColor
    }
}

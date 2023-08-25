//
//  FavouritesScreenVC.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 25/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import SDWebImageSVGCoder

class FavouritesScreenVC: UIViewController {
    
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    let disposeBag = DisposeBag()
    var currencyVM = CurrencyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSVG()
        currencyVM.getAllCurrenciesData()
        showCurrenciesData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func xButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension FavouritesScreenVC {
    
    func showCurrenciesData () {
        
        currencyVM.currenciesArray
            .bind(to: favTableView
                .rx
                .items(cellIdentifier: K.cellsResuable.InSideFTVCell, cellType: InSideFTVCell.self)) {
                    (tv, curr, cell) in
                    if let url = URL(string: curr.flagURL) {
                        cell.currencyImage.sd_setImage(with: url)
                    }
                    cell.currencyNameLabel.text = curr.code
//                    cell.favRadioButton -->
                }
                .disposed(by: disposeBag)
    }
}
extension FavouritesScreenVC {
    func setupUI() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.isOpaque = false
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        favTableView.register(UINib(nibName: K.cellsResuable.InSideFTVCell, bundle: nil), forCellReuseIdentifier: K.cellsResuable.InSideFTVCell)
    }
    func setupSVG() {
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
    }
}

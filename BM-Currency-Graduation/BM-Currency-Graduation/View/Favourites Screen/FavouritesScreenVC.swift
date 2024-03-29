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
    
    let currencyVM: CurrencyViewModel

    init(currencyVm: CurrencyViewModel){
        self.currencyVM = currencyVm
        super.init(nibName: "FavouritesScreenVC", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        currencyVM.getAllCurrenciesData()
        showCurrenciesData()
    }
    
    @IBAction func xButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension FavouritesScreenVC {
    
    func showCurrenciesData () {
        currencyVM.CurrencyData
            .bind(to: favTableView
                .rx
                .items(cellIdentifier: K.cellsResuable.InSideFTVCell, cellType: InSideFTVCell.self)) {
                    (tv, curr, cell) in
                    let favouriteItem = FavouriteItem(currencyCode: curr.key, imageUrl: curr.key)
                    cell.currencyImage.sd_setImage(with: self.currencyVM.imageURL(currecnyCode: curr.key))
                    cell.currencyNameLabel.text = curr.key
                    cell.favRadioButton.isChecked = FavouritesManager.shared().isItemFavorited(item: favouriteItem)
                    cell.onFavButtonTapped = {
                        if cell.favRadioButton.isChecked {
                            FavouritesManager.shared().addToFavorites(item: favouriteItem)
                        } else {
                            FavouritesManager.shared().removeFromFavorites(item: favouriteItem)
                        }
                        self.currencyVM.favouritesArray.accept(FavouritesManager.shared().getAllFavoriteItems())
                    }
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
}

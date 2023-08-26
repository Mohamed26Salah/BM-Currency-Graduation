//
//  ViewController.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 23/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var convertSegmentView: UIView!
    @IBOutlet weak var compareSegmentView: UIView!
    
//    var convertVC: ConvertViewController?
//    var compareVC: CompareViewController?
//    var favouritesVC: FavouritesScreenVC?
    
    let disposeBag = DisposeBag()
//    var currencyVM = CurrencyViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
//        currencyVM.getAllCurrenciesData()
//        passViewModelToViews()
       
//        self.view.bringSubviewToFront(convertSegmentView)
        convertSegmentView.superview?.bringSubviewToFront(convertSegmentView)
    }

    @IBAction func segementAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
//            compareSegmentView.superview?.bringSubviewToFront(compareSegmentView)
            convertSegmentView.isHidden = false
            compareSegmentView.isHidden = true
        case 1:
//            convertSegmentView.superview?.bringSubviewToFront(convertSegmentView)
            compareSegmentView.isHidden = false
            convertSegmentView.isHidden = true
        default:
            break
        }
    }
    
}
//extension ViewController {
//    func passViewModelToViews() {
//        for vc in children {
//            if let convertVC = vc as? ConvertViewController {
//                self.convertVC = convertVC
//                break
//            }
//            if let compareVC = vc as? CompareViewController {
//                self.compareVC = compareVC
//                break
//            }
//            if let favouritesVC = vc as? FavouritesScreenVC {
//                self.favouritesVC = favouritesVC
//                break
//            }
//        }
////        convertVC?.comingCurrencyVM = currencyVM
////        compareVC?.comingCurrencyVM = currencyVM
////        favouritesVC?.comingCurrencyVM = currencyVM
//    }
//}


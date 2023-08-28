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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        convertSegmentView.superview?.bringSubviewToFront(convertSegmentView)
    }

    @IBAction func segementAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            convertSegmentView.isHidden = false
            compareSegmentView.isHidden = true
        case 1:
            compareSegmentView.isHidden = false
            convertSegmentView.isHidden = true
        default:
            break
        }
    }
    
}


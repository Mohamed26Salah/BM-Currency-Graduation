//
//  ViewController.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 23/08/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var convertSegmentView: UIView!
    @IBOutlet weak var compareSegmentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


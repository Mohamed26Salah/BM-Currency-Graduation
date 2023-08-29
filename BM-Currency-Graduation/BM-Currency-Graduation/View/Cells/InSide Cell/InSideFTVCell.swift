//
//  InSideFTVCell.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 24/08/2023.
//

import UIKit

class InSideFTVCell: UITableViewCell {

    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var favRadioButton: RadioButton!
    var onFavButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favButtonTapped(_ sender: RadioButton) {
        onFavButtonTapped?()
    }
    
}

//
//  OutSideFTVCell.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 24/08/2023.
//

import UIKit

class OutSideFTVCell: UITableViewCell {

    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyAmountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//
//  PriceCollectionViewCell.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 29.04.2022.
//

import UIKit

class PriceCollectionViewCell: UICollectionViewCell {

    static let identifier = "PriceCollectionViewCell"
    
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var productDescriptionLabel : UILabel!
    @IBOutlet weak var productPriceLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    static func nib() -> UINib {
        return UINib(nibName: "PriceCollectionViewCell", bundle: nil)
    }
}
